extends Control

class_name  VFX_class

var wielder

var attached_to_wielder = false

	
	
	
func _process(_delta: float) -> void:
	if attached_to_wielder and wielder:
		self.global_position = wielder.particle_holder.global_position
		modulate.a = wielder.modulate.a
	else:
		set_process(false)
