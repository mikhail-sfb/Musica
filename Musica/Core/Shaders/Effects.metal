//
//  Effects.metal
//  Musica
//
//  Created by Miksa on 16.10.25.
//

#include <metal_stdlib>
using namespace metal;

[[stitchable]] half4 waveDistortion(float2 position, half4 color, float2 size, float time) {
    float2 uv = 2.0 * (position / size) - 1.0;
    uv.x *= size.x / size.y;
    
    float2 wobbleUV = uv + sin(uv.y * 20 + time) * 0.05;
    half3 baseColor = half3(0.45, 0.35, 0.85);
    
    half3 stripes = half3(sin(wobbleUV.y * 50.0) * 0.5 + 0.5);
    
    return half4(baseColor * stripes, 1.0);
}
