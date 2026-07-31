extends VFX_class

@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D

func _ready() -> void:
	if wielder.faction == "alpha":
		rotation = 40.0
	wielder._on_slacksus_mouse_exited()
	gpu_particles_2d.emitting = true
	await get_tree().create_timer(0.2*gpu_particles_2d.lifetime).timeout
	wielder.animating = false
	visible = false
	


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
