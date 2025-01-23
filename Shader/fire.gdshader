shader_type spatial;

uniform vec3 effect_color: source_color = vec3(0.56, 0.272, 0.24);
uniform int octave_count: hint_range(1, 20) = 1;
uniform float amp_start = 0.07;
uniform float amp_coeff = 0.225;
uniform float freq_coeff = 2.0;
uniform float speed = 3.5;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

vec2 hash22(vec2 uv) {
	uv = vec2(dot(uv, vec2(127.1,311.7)),
			dot(uv, vec2(269.5,183.3)));
	return 2.0 * fract(sin(uv) * 43758.5453123) - 1.0;
}

float noise(vec2 uv) {
	vec2 iuv = floor(uv);
	vec2 fuv = fract(uv);
	vec2 tuv = fuv * fuv* (3.0 - 2.0 * fuv*fuv);
	return -mix(mix(dot(hash22(iuv + vec2(0.0,0.0)), fuv - vec2(0.0,0.0)),
					dot(hash22(iuv + vec2(1.0,0.0)), fuv - vec2(1.0,0.0)), tuv.x),
				mix(dot(hash22(iuv + vec2(0.0,1.0)), fuv - vec2(0.0,1.0)),
					dot(hash22(iuv + vec2(1.0,1.0)), fuv - vec2(1.0,1.0)), tuv.x), tuv.y);
}

float fbm(vec2 uv, int octaves) {
	float value = 0.0;
	float amplitude = amp_start;
		for (int i = 0; i < octaves; i++) {
		value += amplitude * noise(uv+vec2(0.0,TIME*speed));
		uv *= freq_coeff;
		amplitude *= amp_coeff;
		}
	return value;
	}

void fragment() {
	vec2 uv = 2.0 * UV - 1.0;
	uv += fbm(uv+vec2(0.0,TIME*speed*1.5), octave_count);
	float dist = abs(uv.x);
	float top =  smoothstep(1.0,0.0,-uv.y+0.9);
	float top1 = smoothstep(1.0,-1.3+sin(TIME*1.334-uv.x*0.3)+cos(TIME*0.3-uv.x*0.3),-uv.y+0.5);
	float left = smoothstep(1.0,0.0,-uv.x*1.3);
	float right = smoothstep(1.0,0.0,uv.x*1.3);
	vec3 color = effect_color/dist;
	vec3 gradient = mix(vec3(.0,0.1,0.4),color,-uv.y+1.0);
	ALBEDO = vec3(top*top1*left*right*color*gradient);
	if(length(ALBEDO)<=1.0){
		ALPHA=0.0;
	}
	
}

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;

	// Billboard Mode: Y-Billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}



