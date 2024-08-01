shader_type canvas_item;

uniform sampler2D screen: hint_screen_texture;
uniform float distortion: hint_range(-1.0, 1.0) = -0.33;
uniform sampler2D noise: repeat_enable;
uniform float noise_scroll: hint_range(0.0, 1.0) = 0.2;

void fragment() {
	vec4 mask_pixel = texture(TEXTURE, UV);
	vec4 noise_pixel = texture(noise, UV + noise_scroll * TIME);
	COLOR = texture(screen, SCREEN_UV + distortion * mask_pixel.r);
}
