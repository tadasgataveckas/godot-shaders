shader_type canvas_item;

uniform sampler2D scrn_tex:  hint_screen_texture, filter_linear;
uniform sampler2D captured_texture;

void fragment() {
	vec2 suv = SCREEN_UV;
	vec4 color = mix(texture(scrn_tex,suv),texture(captured_texture,suv),0.5);
	COLOR = color;
	
}