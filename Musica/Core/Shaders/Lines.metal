//
//  Lines.metal
//  Musica
//
//  Created by Miksa on 30.10.25.
//

#include <metal_stdlib>
using namespace metal;


float renderLine(float2 uv, float time) {
    //uv = float2(uv.x, 1 - uv.y);
    float expectedY = 1 - pow(min(cos((M_PI_H * uv.x) / 2), 1.0 - abs(uv.x)), 0.5);
    
    float dist = uv.y - expectedY + 0.2;
    
    return dist >= 0 ? 1 - smoothstep(0, 0.01, dist) : abs(sin(time));
}

[[stitchable]] half4 lines(float2 position, half4 color, float2 size, float time) {
    float2 uv = (position / size) * 2 - 1;
    float aspectRatio = size.y / size.x;

    // float line = renderLine(uv, time);
    //    float left = step(-0.5, uv.x);
    //    float bottom = step(-0.5, uv.y);
    //    float right = step(0.5, 1.0 - uv.x);
    //    float top = step(0.5,1.0 - uv.y);
    //    float rect = left * bottom * right * top;
    
    float2 pixelPosition = float2(uv.x, uv.y * aspectRatio);
    float2 center = 0;
    float borderWidth = 0.005;
    float radius = 0.3;
    
    float distanceToBorder = abs(distance(pixelPosition, center) - radius);
    float border = smoothstep(0,borderWidth, distanceToBorder);
    half3 blueBorder = half3(0,0,1) * border;
    
    float inCircle = 1 - distance(pixelPosition, float2(0,0));
    float borderDistance = distance(radius, pixelPosition);
    
    float circle = step(radius, inCircle);
    
    half3 newColor = circle * blueBorder;
    
    return half4(newColor, 1);
}
