extends VFX_class

@onready var clipper: Control = %Clipper
@onready var biceps: TextureRect = %Biceps
@onready var world_environment: WorldEnvironment = %WorldEnvironment




var clipper_step = 15
var biceps_step = 1
var final_scale = Vector2(1.2,1.2)
var og_scale = Vector2(1.0,1.0)

var animation_duration = 1.0
var scaling_duration = 0.6
var tween_duration = 0.7

var disappear_time = 0.2

func _ready() -> void:
	#if wielder:
		#wielder.z_index += 100
	var tween = create_tween().set_parallel(true)
	tween.tween_property(biceps, "self_modulate:a", 1.0, tween_duration)
	tween.tween_property(wielder, "scale", final_scale, scaling_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", final_scale, scaling_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)

	
	await get_tree().create_timer(animation_duration).timeout
	
	if wielder:
		wielder.animating = false
		
	var tween2 = create_tween().set_parallel(true)
	
	tween2.tween_property(self, "modulate:a", 0.0, disappear_time)
	tween2.tween_property(wielder, "scale", og_scale, disappear_time)
	tween2.tween_property(self, "scale", og_scale, disappear_time)

	await tween2.finished
	#if wielder:
		#wielder.z_index -= 100
	queue_free()

func _process(delta: float) -> void:
	
	clipper.size.y += clipper_step
	clipper.position.y -= clipper_step
	biceps.position.y += clipper_step - biceps_step
	
	
