shader_type canvas_item;

uniform float luminosity : hint_range(0.0, 1.0);
uniform float saturation : hint_range(0.0, 1.0);

void fragment() {
	vec4 original_colour = texture(TEXTURE, UV);
	vec3 grey = vec3(dot(vec3(luminosity), original_colour.rgb));
	COLOR.rgb = mix(original_colour.rgb, grey, saturation);
	COLOR.a = original_colour.a;
}
