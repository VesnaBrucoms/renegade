shader_type canvas_item;

uniform float red_intensity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 pixelColour = texture(TEXTURE, UV);
	COLOR.rgb = mix(pixelColour.rgb, vec3(1.0, 0.0, 0.0), red_intensity);
}
