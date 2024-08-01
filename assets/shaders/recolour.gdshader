shader_type canvas_item;

uniform vec4 colour : source_color;

void fragment() {
	vec4 current_colour = texture(TEXTURE, UV);
	if (current_colour == vec4(1.0, 1.0, 1.0, 1.0)) {
		COLOR = colour;
	}
}
