extends Control

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $Projectile/AudioStreamPlayer2D

var time_to_travel = 1
var destination:Vector2 

func _ready() -> void:
	push_error("proj destination: " +str(destination))
	audio_stream_player_2d.play()
	var tween = create_tween()
	tween.tween_property(self, "global_position",destination,time_to_travel)
	await tween.finished
	visible=false




func _on_audio_stream_player_2d_finished() -> void:
	self.queue_free()
