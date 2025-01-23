shader_type spatial;
uniform sampler2D tex;


void vertex() {
	VERTEX.z += 0.1 + cos(TIME*0.3);
	VERTEX.x += 0.1 + cos(TIME*0.43);
}

void fragment() {
	vec2 uv = UV;
	uv.x += 1.0 - (TIME * 0.005);
	uv.t += fract(sin(TIME*0.05));
	vec4 color = texture(tex, uv);
	ALBEDO = color.rgb;
	if(color.rgb == vec3(1.0,1.0,1.0))
		ALPHA = clamp(1.0,1.0,1.0);
	else
		ALPHA = clamp(0.0,0.0,0.0);
}
