shader_type canvas_item;
uniform sampler2D tex_frg_2;

uniform vec4 outline_color:hint_color = vec4(1.0,1.0,0.0,1.0);
uniform float inner_circle=0.45;
uniform float outer_circle=0.5;

const vec4 alpha_color= vec4(0,0,0,0);

uniform float smoothness=0.01;

void vertex() {
// Output:0

}

void fragment() {
// Texture:2
	vec4 tex_frg_2_read = texture(tex_frg_2, UV.xy);
	vec3 n_out2p0 = tex_frg_2_read.rgb;
	float n_out2p1 = tex_frg_2_read.a;

// Cicle
	vec2 origin = UV-vec2(0.5,0.5);
	
	float dist =length(origin); //sqrt(dot(origin,origin));
	
	vec4 _color= mix (texture(tex_frg_2,UV),outline_color,smoothstep(inner_circle-smoothness,inner_circle+smoothness,dist));
	 COLOR= mix (_color,alpha_color,smoothstep(outer_circle-smoothness,outer_circle+smoothness,dist));


// Output:0
//	COLOR.rgb = n_out2p0;

}

void light() {
// Output:0

}
