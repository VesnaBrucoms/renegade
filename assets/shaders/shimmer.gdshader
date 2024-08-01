shader_type canvas_item;

uniform sampler2D noise: hint_roughness_normal, repeat_enable;
uniform float noise_scroll: hint_range(0.0, 1.0) = 0.2;
uniform float distortion: hint_range(-1.0, 1.0) = 0.125;
uniform vec4 shade: source_color = vec4(0.75, 0.78, 0.9, 1.0);
uniform vec4 specular_colour: source_color = vec4(0.2, 0.2, 1.0, 1.0);
uniform float light_start: hint_range(0.0, 1.0) = 0.792;
uniform float light_end: hint_range(0.0, 1.0) = 0.917;

void fragment() {
	vec2 noiseUV = UV + noise_scroll * TIME;
	vec4 noiseColour = texture(noise, noiseUV);
	vec2 spriteUV = UV + distortion * noiseColour.r;
	vec4 spriteColour = texture(TEXTURE, spriteUV);
	vec4 specular = smoothstep(light_start, light_end, noiseColour.r) * specular_colour;
	COLOR = spriteColour + shade + specular;
	COLOR.a = spriteColour.a;
}
