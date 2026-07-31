extends VFX_class

@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D


func _ready() -> void:
	attached_to_wielder = true
	await get_tree().create_timer(0.7).timeout
	gpu_particles_2d.emitting = false
	await get_tree().create_timer(gpu_particles_2d.lifetime).timeout
	queue_free()
