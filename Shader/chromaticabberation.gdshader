shader_type canvas_item;
uniform sampler2D scrn_tex:  hint_screen_texture, filter_linear;
uniform float aberration: hint_range(0.0, 1.0, 0.001) = 0.425;
uniform float strength: hint_range(0.0, 0.1, 0.001) = 0.08;

void fragment() {
	vec2 suv = SCREEN_UV;
	float aspect_ratio = SCREEN_PIXEL_SIZE.y/SCREEN_PIXEL_SIZE.x;
	vec2 scaled_suv = (suv - vec2(0.0, 0.5)) / vec2(1.0, aspect_ratio) + vec2(0,0.5);
	vec2 offset = normalize( scaled_suv ) * strength;
	vec2 abber_vec= strength*aberration*offset;

	vec4 red = texture(scrn_tex, suv - abber_vec);
	vec4 blue = texture(scrn_tex, suv + abber_vec);
	vec4 green = texture(scrn_tex, suv);

	COLOR = vec4(red.r,green.g,blue.b,1.0);
}
