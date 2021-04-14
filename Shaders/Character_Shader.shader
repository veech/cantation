shader_type canvas_item;
render_mode unshaded;

uniform vec4 multiply_color : hint_color;

void fragment()
{
	COLOR = texture(TEXTURE , UV) * multiply_color;
	
}
