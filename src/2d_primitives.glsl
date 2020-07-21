precision highp float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

float draw_circle(vec2 curr_pixel, vec2 c_coords, float radius, float blur, float alpha) {
	float d = length(curr_pixel-c_coords);

	float calcCircle = smoothstep(radius, radius-(0.004+blur), d);

	return calcCircle * alpha;
}

float draw_band(float axis, float start, float end, float blur, float alpha) {
	float step1 = smoothstep(start-(0.0004+blur), start+(0.0004+blur), axis);
	float step2 = smoothstep(end+(0.0004+blur), end-(0.0004+blur), axis);

	return step1 * step2 * alpha;
}

float draw_rect(vec2 uv, vec2 c_coords, float width, float height, float blur, float alpha) {
	float band1 = draw_band(uv.x, c_coords.x, c_coords.x + width, blur, alpha);
	float band2 = draw_band(uv.y, c_coords.y, c_coords.y + height, blur, alpha);
	return band1 * band2;
}

vec3 set_color(float shape, vec3 colors) {
	vec3 ret_color = vec3(0.0);

	ret_color.r += shape * colors.r;
	ret_color.g += shape * colors.g;
	ret_color.b += shape * colors.b;

	return ret_color;
}


void main() {
	vec2 uv = gl_FragCoord.xy/u_resolution.xy;
	vec3 color = vec3(0.0, 0.0, 1.0);

	uv.x *= u_resolution.x/u_resolution.y;
	uv.y *= u_resolution.y/u_resolution.x;

	float circle = draw_circle(uv, vec2(0.6, 0.6), 0.2, 0.0, 1.0);
	color -= circle*color;
	color += set_color(circle, vec3(1.0, 0.0, 0.0));

	float side = draw_band(uv.y, 0.9, 0.95, 0.0, 1.0);
	color -= side*color;
	color += set_color(side, vec3(0.0, 0.2, 0.0));

	float rect = draw_rect(uv, vec2(0.6, 0.6), 0.1, 0.1, 0.0, 1.0);
	color -= rect*color;
	color += set_color(rect, vec3(0.0, 1.0, 0.9));

	gl_FragColor = vec4(color, 1.0);
}
