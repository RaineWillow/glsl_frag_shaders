precision highp float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

float draw_circle(vec2 curr_pixel, vec2 c_coords, float radius, float blur) {
	float d = length(curr_pixel-c_coords);

	float calcCircle = smoothstep(radius, radius-(0.004+blur), d);

	return calcCircle;
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

	for (float i = 0.0; i < 6.0; i += 0.2) {
		float circ1 = draw_circle(uv, vec2(abs(sin(u_time*0.7)), i), 0.01*sin(u_time)+0.1, uv.x*0.04);

		color -= color * circ1;

		color += set_color(circ1, vec3(uv.x, 0.5, 0.2));
	}


	gl_FragColor = vec4(color, 1.0);
}
