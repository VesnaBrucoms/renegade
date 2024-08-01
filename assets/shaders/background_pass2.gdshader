shader_type canvas_item;

uniform sampler2D mask;
uniform sampler2D noise_1: repeat_enable;
uniform sampler2D noise_2: repeat_enable;
uniform float noise_1_scroll: hint_range(0.0, 1.0) = 0.1;
uniform float noise_2_scroll: hint_range(0.0, 1.0) = 0.2;
uniform sampler2D colour: repeat_enable;

void fragment() {
	vec4 mask_pixel = texture(mask, UV);
	vec2 noise_1_uv = UV + noise_1_scroll * TIME;
	vec2 noise_2_uv = vec2(UV.x + noise_2_scroll * TIME, UV.y - noise_2_scroll * TIME);
	vec4 noise_1_pixel = texture(noise_1, noise_1_uv);
	vec4 noise_2_pixel = texture(noise_2, noise_2_uv);
	vec4 final = texture(colour, vec2(noise_1_pixel.r * noise_2_pixel.r));
	final.a = mask_pixel.r;
	COLOR = final;
}
