shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform float scroll_speed: hint_range(0.0, 1.0) = 0.2;
uniform float density: hint_range(0.0, 1.0) = 0.1;

void fragment() {
	vec2 noise_uv = vec2(UV.x, UV.y - scroll_speed * TIME);
	vec4 noise_pixel = texture(noise, noise_uv);
	noise_pixel.a = max(noise_pixel.r - density, 0.0);
	COLOR = noise_pixel;
}
