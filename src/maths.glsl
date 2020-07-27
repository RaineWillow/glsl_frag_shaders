float rand2D(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float smooth_noise(vec2 uv) {
	vec2 lv = smoothstep(0.0, 1.0, fract(uv*10.0));
	vec2 id = floor(uv*10.0);

	float b1 = rand2D(id);
	float br = rand2D(id+vec2(1.0, 0.0));
	float b = mix(b1, br, lv.x);

	float t1 = rand2D(id + vec2(0.0, 1.0));
	float tr = rand2D(id + vec2(1.0, 1.0));
	float t = mix(t1, tr, lv.x);

	return mix(b, t, lv.y);
}

float smoother_noise(vec2 uv) {
	float c = smooth_noise(uv*4.0);
	c += smooth_noise(uv*8.0) * 0.5;
	c += smooth_noise(uv*16.0) * 0.25;
	c += smooth_noise(uv*32.0) * 0.125;
	c += smooth_noise(uv*64.0) * 0.0625;
	c += smooth_noise(uv*128.0) * 0.03125;
	return c/2.0;
}

float smootherstep(float edge0, float edge1, float x) {
  // Scale, and clamp x to 0..1 range
  x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
  // Evaluate polynomial
  return x * x * x * (x * (x * 6.0 - 15.0) + 10.0);
}
