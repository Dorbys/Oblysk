extends VFX_class

@onready var camera = $"../../Camera2D"
var fade_animation_duration:float = 0.8


func _ready() -> void:
	modulate.a = 0
	#Base.Combat_phase = true
	camera.movement_locked = true
	var tween1 = create_tween()
	tween1.tween_property(self, "modulate:a", 1, Base.camera_move_time_short)
	await camera.move_camera_to_lane(Base.current_lane)
	
	wielder.animating = false
	await get_tree().create_timer(SpellsDB.get_into_duel_time + Base.SMASH_animation_time ).timeout
	
	camera.movement_locked = false
	var tween2 = create_tween()
	tween2.tween_property(self, "modulate:a", 0, fade_animation_duration)
	await tween2.finished
	
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	wielder.MYrena_rect.collide_units(true)
	wielder.MYrena_rect.OPrena_rect.collide_units(true)
	#Base.Combat_phase = false
	#might be dangerous to modify this outside thursday
	queue_free()
	
	
	
	
	
	
	
	
	
	
