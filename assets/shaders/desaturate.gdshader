shader_type canvas_item;

uniform vec3 luminosity : source_color;

void fragment() {
	vec4 original_colour = texture(TEXTURE, UV);
	vec3 grey = vec3(dot(luminosity, original_colour.rgb));
	COLOR = vec4(grey, original_colour.a);
}
