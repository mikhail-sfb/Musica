//
//  ColorRound.metal
//  Musica
//
//  Created by Miksa on 15.10.25.
//

#include <metal_stdlib>
using namespace metal;


[[stitchable]] half4 colorRound(float2 position, half4 color, float2 size, float time) {
    
    float aspectRatio = size.y / size.x;
    float2 uv = position / size;

    float2 center = float2(0.5, 0.5 * aspectRatio);
    
    float radiusArc = 0.35;
    float borderWidth = 0.005;
    float radiusBorder = radiusArc + borderWidth + 0.05;
    float2 aspecRatioPosition = float2(uv.x, uv.y * aspectRatio);
    
    float distanceToBorder = abs(distance(aspecRatioPosition, center) - radiusBorder);
    float distanceToArc = abs(distance(aspecRatioPosition, center) - radiusArc);
    
    // masks
    // max - logical or || ; min - logical and &&
    
    float circle = distanceToArc < 0.05;
    float border = distanceToBorder < borderWidth;
    
    half3 arcColor = half3(uv.x, 1 - uv.y, clamp(cos(time * 2) + sin(time), 0.0, 1.0));
    half3 permuted = half3(1 - uv.y, uv.x, cos(time * 2));
    float t = abs(sin(time));
    half3 result = mix(arcColor, permuted, t);
    
    float totalMax = max(circle, border);
    half3 finalColor = border > 0.0 ? half3(0, 0, 0) : result;
    
    return half4(finalColor, color.a * totalMax);
}

// SDF = Signed Distance Function - умная функция расстояния!
// • sdf < 0 → "я внутри круга" → закрашиваю пиксель
// • sdf > 0 → "я снаружи круга" → НЕ закрашиваю
// • sdf = 0 → "я на границе круга" → граница

float3 rotateY(float3 p, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return float3(c * p.x + s * p.z, p.y, -s * p.x + c * p.z);
}

float3 rotateX(float3 p, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return float3(p.x, c * p.y - s * p.z, s * p.y + c * p.z);
}

float sdfSphere(float3 point, float3 center, float radius, float time) {
    float3 rotatedPoint = rotateY(rotateX(point, time * 0.8), time * 0.5);
    return length(rotatedPoint - center) - radius;
}

float3 getNormal(float3 p, float time) {
    float2 e = float2(0.01, 0.0);
    return normalize(float3(
        sdfSphere(p + e.xyy, float3(0,0,0), 0.5, time) - sdfSphere(p - e.xyy, float3(0,0,0), 0.5, time),
        sdfSphere(p + e.yxy, float3(0,0,0), 0.5, time) - sdfSphere(p - e.yxy, float3(0,0,0), 0.5, time),
        sdfSphere(p + e.yyx, float3(0,0,0), 0.5, time) - sdfSphere(p - e.yyx, float3(0,0,0), 0.5, time)
    ));
}

float rayMarch(float3 rayOrigin, float3 rayDirection, float time) {
    float totalDistance = 0.0;
    
    for (int i = 0; i < 32; i++) {
        float3 currentPos = rayOrigin + rayDirection * totalDistance;
        float distanceToSurface = sdfSphere(currentPos, float3(0,0,0), 0.5, time);
        
        if (distanceToSurface < 0.001) {
            return totalDistance;
        }
        
        totalDistance += distanceToSurface;
        
        if (totalDistance > 10.0) break;
    }
    
    return -1.0;
}

[[stitchable]] half4 sphere(float2 position, half4 color, float2 size, float time) {
    float2 uv = (position - size * 0.5) / min(size.x, size.y);
    
    float3 rayOrigin = float3(0, 0, -2);
    float3 rayDirection = normalize(float3(uv.x, uv.y, 1.0));
    
    float distance = rayMarch(rayOrigin, rayDirection, time);
    
    if (distance > 0.0) {
        float3 hitPoint = rayOrigin + rayDirection * distance;
        float3 normal = getNormal(hitPoint, time);
        
        float3 lightPos = float3(sin(time) * 3.0, cos(time) * 2.0, -3.0);
        float3 lightDir = normalize(lightPos - hitPoint);
        
        float rawLighting = dot(normal, lightDir);
        float lighting = 0.4 + 0.6 * smoothstep(-0.5, 1.0, rawLighting);
        
        // Создаем плавные цветовые зоны на вращающейся сфере
        float3 rotatedHit = rotateY(rotateX(hitPoint, time * 0.8), time * 0.5);
        
        // Плавные волны для видимого вращения
        float wave1 = sin(rotatedHit.x * 8.0) * 0.3;
        float wave2 = sin(rotatedHit.y * 6.0) * 0.2;
        float wave3 = sin(rotatedHit.z * 10.0) * 0.25;
        
        // Базовые цвета с волнами
        float3 baseColor = float3(
            0.5 + 0.4 * sin(time * 0.8) + wave1,
            0.5 + 0.4 * sin(time * 0.8 + 2.0) + wave2,
            0.5 + 0.4 * sin(time * 0.8 + 4.0) + wave3
        );
        float3 finalColor = baseColor * (lighting * 0.7 + 0.3);
        
        return half4(half3(finalColor), color.a);
    }
    
    return half4(0, 0, 0, 1);
}
