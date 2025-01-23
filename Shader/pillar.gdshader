shader_type spatial;
uniform vec3 color: source_color;
uniform vec3 ringcolor: source_color;
uniform float speed = 1.0;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	float height = uv.y*32.0;
	float width = uv.x*3.2;
	float ringsy = sin((height+TIME*speed)*0.5);
	float ringsx = sin((width+TIME*speed)*1.0);
	float ringmap = smoothstep(0.0, 0.5, tan(ringsy*3.0)*0.0769+sin(ringsy*83.0)+sin(ringsy*7.0));
	float ringmask = smoothstep(0.0,0.5,abs(sin(ringsx*2.0)));
	ringmap = ringmap*ringmask;
	EMISSION = ringmap*ringcolor;
	ALBEDO = mix(color,ringcolor,ringmap);
}


