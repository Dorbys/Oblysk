shader_type canvas_item;

uniform float grayscaleIntesity = 1;

void fragment() {
	
	float grayscale = (COLOR.r + COLOR.g + COLOR.b) / 3.0 * grayscaleIntesity;
	
	COLOR = vec4(grayscale, grayscale, grayscale, COLOR.a);
}