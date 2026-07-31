extends Control

@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var effect: TextureRect = %Effect

var wielder:Node

#var scale_up = Vector2(0.96,0.96)
var scale_up = Vector2(1.2,1.2)
var scaling_time = 0.16
var modulation_time = 0.5
var emit_delay = 0.63
var exit_delay = 1.65

func _ready() -> void:
	if wielder:
		wielder.z_index = 3
	audio_stream_player_2d.play()
	delayed_emit()
	delayed_exit()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(effect, "scale", scale_up, scaling_time)
	
	#await get_tree().create_timer(0.8 * scaling_time).timeout
	tween.tween_property(effect, "self_modulate:a", 0, modulation_time).set_delay(0.8 * scaling_time)
	
func delayed_emit():
	await get_tree().create_timer(emit_delay).timeout
	gpu_particles_2d.emitting = true
	
func delayed_exit():
	await get_tree().create_timer(exit_delay).timeout
	if wielder:
		wielder.z_index = 0
	queue_free()
