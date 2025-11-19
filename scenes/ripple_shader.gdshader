shader_type canvas_item;

uniform vec2 ripple_center = vec2(0.5, 0.5); // Normalized position (0-1)
uniform float time = 0.0;
uniform float ripple_speed = 5.0;
uniform float ripple_amplitude = 0.1;
uniform float ripple_frequency = 10.0;
uniform float ripple_dropoff = 2.0;
uniform vec4 base_color = vec4(0.0, 0.5, 1.0, 1.0);
uniform float pixel_size = 16.0;

void fragment() {
    vec2 uv = UV;
    vec2 snapped_uv = floor(uv * pixel_size) / pixel_size;
    vec2 center = ripple_center;
    
    float dist = distance(snapped_uv, center);
    float falloff = exp(-dist * ripple_dropoff);
    float wave = sin(dist * ripple_frequency - time * ripple_speed) * ripple_amplitude * falloff;
    
    float intensity = 1.0 + wave;
    COLOR = base_color * intensity;
}