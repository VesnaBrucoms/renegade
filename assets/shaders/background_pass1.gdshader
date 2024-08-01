shader_type canvas_item;

uniform float hdr_threshold: hint_range(0.0, 1.0) = 0.2; // Glow is applied when greater than this.
uniform float glow_intensity: hint_range(0.0, 1.0) = 0.25;

vec4 sample_glow_pixel(sampler2D tex, vec2 uv) {
	return max(texture(tex, uv) - hdr_threshold, vec4(0.0));
}

void fragment() {
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;
	vec4 up_pixel = sample_glow_pixel(TEXTURE, UV + vec2(0, -pixel_size.y));
	vec4 right_pixel = sample_glow_pixel(TEXTURE, UV + vec2(pixel_size.x, 0));
	vec4 down_pixel = sample_glow_pixel(TEXTURE, UV + vec2(0, pixel_size.y));
	vec4 left_pixel = sample_glow_pixel(TEXTURE, UV + vec2(-pixel_size.x, 0));
	
	vec4 bg_pixel = texture(TEXTURE, UV);
	vec4 glowing_pixel = glow_intensity * (up_pixel + right_pixel + down_pixel + left_pixel);
	
	COLOR = vec4(bg_pixel.rgb + glowing_pixel.rgb, bg_pixel.a);
}
