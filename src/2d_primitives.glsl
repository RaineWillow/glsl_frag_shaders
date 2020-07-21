precision highp float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;


//draw a circle onto the screen
//dependancies: none
float draw_circle(vec2 curr_pixel, vec2 c_coords, float radius, float blur, float alpha) {
	float d = length(curr_pixel-c_coords);

	float calcCircle = smoothstep(radius, radius-(0.001+blur), d);

	return calcCircle * alpha;
}

//draw a band onto the screen.
//dependancies: none
float draw_band(float axis, float start, float end, float blur, float alpha) {
	float step1 = smoothstep(start-(0.0004+blur), start+(0.0004+blur), axis);
	float step2 = smoothstep(end+(0.0004+blur), end-(0.0004+blur), axis);

	return step1 * step2 * alpha;
}


//draw a rectangle onto the screen.
//dependancies: draw_band
float draw_rect(vec2 uv, vec2 c_coords, float width, float height, float blur, float alpha) {
	float band1 = draw_band(uv.x, c_coords.x, c_coords.x + width, blur, alpha);
	float band2 = draw_band(uv.y, c_coords.y, c_coords.y + height, blur, alpha);
	return band1 * band2;
}

float edge_function(vec2 a, vec2 b, vec2 c) {
	return smoothstep(0.0, 1.0, (c.x - a.x) * (b.y - a.y) - (c.y - a.y) * (b.x - a.x));
}

float draw_triangle(vec2 uv, vec2 v_1, vec2 v_2, vec2 v_3, float blur, float alpha) {
	float data = ceil(edge_function(v_1, v_2, uv) * edge_function(v_2, v_3, uv) * edge_function(v_3, v_1, uv));
	return data*alpha;
}


//color a shape before applying it to the main color
vec3 set_color(float shape, vec3 colors) {
	vec3 ret_color = vec3(0.0);

	ret_color.r += shape * colors.r;
	ret_color.g += shape * colors.g;
	ret_color.b += shape * colors.b;

	return ret_color;
}

//examples for each function
void main() {
	vec2 uv = gl_FragCoord.xy/u_resolution.xy;
	vec3 color = vec3(0.0, 0.0, 1.0);

	//apply an aspect ratio
	uv.x *= u_resolution.x/u_resolution.y;
	uv.y *= u_resolution.y/u_resolution.x;

	//draw a circle
	float circle = draw_circle(uv, vec2(0.6, 0.6), 0.2, 0.0, 1.0);
	//apply a mask
	color -= circle*color;
	//add a colored version of the shape to the main color var
	color += set_color(circle, vec3(1.0, 0.0, 0.6));

	float side = draw_band(uv.y, 0.9, 0.95, 0.0, 1.0);
	color -= side*color;
	color += set_color(side, vec3(0.0, 0.2, 0.0));

	float side2 = draw_band(uv.x, 0.9, 0.95, 0.0, 1.0);
	color -= side2*color;
	color += set_color(side2, vec3(0.0, 0.2, 0.0));

	float rect = draw_rect(uv, vec2(0.1, 0.2), 0.3, 0.3, 0.0, 1.0);
	color -= rect*color;
	color += set_color(rect, vec3(0.8, 0.5, 0.0));


	float tri = draw_triangle(uv, vec2(0.3, 0.1), vec2(0.3, 0.19), vec2(0.4, 0.19), 0.1, 1.0);
	color -= tri*color;
	color += set_color(tri, vec3(0.0, 1.0, 0.0));

	gl_FragColor = vec4(color, 1.0);
}
