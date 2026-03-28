#version 300 es
precision highp float;

uniform sampler2D tex;
in vec2 v_texcoord;
out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);

    // luminance
    float luma = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    // chroma (range of RGB)
    float maxc = max(max(color.r, color.g), color.b);
    float minc = min(min(color.r, color.g), color.b);
    float chroma = maxc - minc;

    // --- tuned parameters ---
    float vibrance = 1.2;   // main strength (~90% DV)
    float satLimit = 0.85;  // compress already saturated colors
    float highlightStart = 0.65;

    // base boost: stronger for low chroma
    float boost = 1.0 + vibrance * (1.0 - chroma);

    // compress high saturation (prevents neon colors)
    float satMask = smoothstep(satLimit, 1.0, chroma);
    boost = mix(boost, 1.0, satMask);

    // highlight protection (prevents washed whites)
    float highlightMask = smoothstep(highlightStart, 1.0, luma);
    boost = mix(boost, 1.0, highlightMask);

    // apply relative to grayscale
    vec3 gray = vec3(luma);
    vec3 result = mix(gray, color.rgb, boost);

    fragColor = vec4(result, color.a);
}