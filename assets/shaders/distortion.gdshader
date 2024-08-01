shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float distortion_intensity : hint_range(0.0, 0.5);

void fragment() {
	vec2 distortedUV = SCREEN_UV + texture(TEXTURE, UV).a * distortion_intensity;
	vec4 screenPixelColour = texture(SCREEN_TEXTURE, distortedUV);
	COLOR = screenPixelColour;
}
