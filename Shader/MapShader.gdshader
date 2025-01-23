shader_type spatial;

//texture
uniform sampler2D colorTex;
uniform sampler2D roughTex;
uniform sampler2D displaceTex;
uniform sampler2D normalTex;


uniform sampler2D snowmask;
uniform sampler2D footstepDepthTex;
uniform sampler2D shockwaveDepthTex;


void vertex() {
	vec4 footstepDeform = texture(footstepDepthTex,UV);
	vec4 shockwaveDeform = texture(shockwaveDepthTex,UV);
	vec4 blend1 = mix(shockwaveDeform,footstepDeform,0.5);
	float h = texture(displaceTex,UV).r*50.0;
	float nh = blend1.r*50.0;
	VERTEX = vec3(VERTEX.x,nh,VERTEX.z);
	//VERTEX.y += texture(snowmask, UV).r * 100.9;
}

void fragment() {
	vec2 uv = UV;
	vec4 _albedo = texture(colorTex, uv);
	vec4 _footstepMask = texture(snowmask,uv);
	vec3 _maskedCol = _albedo.rgb * _footstepMask.r * 0.5;
	ALBEDO = _maskedCol;
	vec3 _normal = texture(normalTex, uv).rgb;
	NORMAL = _normal;
	float _roughness = texture(roughTex, uv).r;
	ROUGHNESS = _roughness;
}
