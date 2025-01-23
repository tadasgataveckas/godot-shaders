shader_type canvas_item;

uniform sampler2D scrn_tex:  hint_screen_texture, filter_linear;
uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;


void fragment() {
	vec2 suv = SCREEN_UV;
	vec3 c = texture(scrn_tex, suv).rgb;
	c.rgb = mix(vec3(0.0), c.rgb, brightness);
	c.rgb = mix(vec3(0.5), c.rgb, contrast);
	c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);
	COLOR.rgb = c;
}
