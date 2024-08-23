shader_type canvas_item;

uniform float cooldown : hint_range(0, 2);

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
    float gray = dot(tex_color.rgb, vec3(1, 0, 0));
    vec3 gray_color = vec3(gray, gray, gray);
    COLOR.rgb = mix(tex_color.rgb, gray_color, cooldown / 2.0);
    COLOR.a = tex_color.a;
}
