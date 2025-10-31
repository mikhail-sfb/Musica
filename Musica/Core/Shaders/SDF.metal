//
//  SDF.metal
//  Musica
//
//  Created by Miksa on 16.10.25.
//

#include <metal_stdlib>
using namespace metal;

// https://www.youtube.com/watch?v=Ow9JDz_qYpw&list=LL&index=2&t=473s
// sdf - signed distant function
// function takes 2D coordinate that returns a number
// distance - the number the function returns is a distance between the given coordinate and surface of some shape
// signed - positive output when outside, negative if inside; 0 - on the border

// we take each pixel and compute sdf, usually a fragment shader (that changes color
// bright pixels depending on a distance)

// float sdfTestFunction(float2 uv)

// мне нужно подробнее про SDF почитать, а также эффекты, + как комбинировать тригонометрические функции
// как двигать объекты в метале

float sdCircle(float2 p, float r )
{
    return length(p) - r;
}

[[stitchable]] half4 testSDF(float2 position, half4 color, float2 size, float time) {
    float2 uv = 2.0 * (position / size) - 1.0; // Convert to [-1, 1] range
    // float threshold = 0.5;
    uv.x *= size.x / size.y;
    
    //half3 starColor = half3(0,0,0);
    
    float distance = sdCircle(uv, 0.2);
    float outerGlow = 1.0 - smoothstep(0.0, 0.2, distance);
    half3 glowColor = half3(0.0, 0.3, 0.8) * outerGlow;
    
    float pulseWidth = outerGlow;
    float pulse = sin(distance * 20.0 - time * 4.0) * 0.5 + 0.5;
    float pulseEffect = pulse * (1.0 - smoothstep(0.0, pulseWidth, abs(distance)));
    half3 pulseColor = half3(0.4, 0.2, 0.6) * pulseEffect;
    
    float outwardWaves = sin(distance * 20.0 - time * 4.0) * 0.5 + 0.5;
    outwardWaves *= 1.0 - smoothstep(0.0, 0.3, distance);
    half3 waveColor = half3(0.2, 0, 0.9) * outwardWaves;
    
    half3 finalColor = glowColor + pulseColor + waveColor;
    
    if (distance < 0.0) {
        finalColor += half3(0.1, 0.1, 0.3);
    }
    
//    float t = abs(sin(time));
//    if (distance < threshold / 1.5){
//        starColor = mix(starColor, half3(0.2, 0.2, 0.8), t);
//    }
//    
//    float t2 = abs(cos(time) + sin(time));
//    if (distance < threshold / 3){
//        starColor = mix(starColor, half3(0.8, 0.8, 0.2), t2);
//    }
    
    return half4(finalColor, 1);
}
