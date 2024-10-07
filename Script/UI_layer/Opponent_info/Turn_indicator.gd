extends TextureRect



@export var active_texture: Texture
@export var inactive_texture: Texture
# Called when the node enters the scene tree for the first time.

func active_texture_now():
#	push_error("setting in Turn indic")
	texture = active_texture
	
func inactive_texture_now():
	texture = inactive_texture
	
	
