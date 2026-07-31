extends VFX_class

#for vfx like Heal_vfx which oneshot emit
	#handles wielder attachment and quefreeing

@export var following_wielder:bool

@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D

func _ready() -> void:
	gpu_particles_2d.emitting = true
	attached_to_wielder = following_wielder
	await get_tree().create_timer(2 * gpu_particles_2d.lifetime).timeout
	queue_free()
