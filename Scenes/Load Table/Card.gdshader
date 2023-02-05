shader_type canvas_item;
uniform sampler2D Dice_Tex;
uniform sampler2D Tex;
uniform vec3 color;
uniform float alpha;



void vertex() {
// Output:0

}

void fragment() {
// Color:10
	vec3 n_out10p0 = vec3(color);
	float n_out10p1 = 1.000000;

// Texture:9
	vec4 tex_frg_9_read = texture(Dice_Tex, UV.xy);
	vec3 n_out9p0 = tex_frg_9_read.rgb;
	float n_out9p1 = tex_frg_9_read.a;

// VectorScalarMix:8
	vec3 n_out8p0 = mix(n_out10p0, n_out9p0, n_out9p1);

// TextureUniform:12
	vec3 n_out12p0;
	float n_out12p1;
	{
		vec4 n_tex_read = texture(Tex, UV.xy);
		n_out12p0 = n_tex_read.rgb;
		n_out12p1 = n_tex_read.a;
	}

// VectorScalarMix:11
	float n_in11p2 = alpha;
	vec3 n_out11p0 = mix(n_out8p0, n_out12p0, n_in11p2);

// Output:0
	COLOR.rgb = n_out11p0;

}

void light() {
// Output:0

}