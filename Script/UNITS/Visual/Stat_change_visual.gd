extends VFX_class

var stat_change_value:int
	#given by caller
	
var target_stat_position:Vector2
	#to determine where to put label	
	
var simultaneous_position:int
	#given by caller
	#moves me up, to not cover simultaneous myselfs (eg acamar passive) 	
	
var tween_duration = 1.2

var default_movement = 50
	#I need to get above(y) the stat label I explain and above(y) other SCAs
	
func _ready() -> void:
	attached_to_wielder = true
	pivot_offset = %HP.position + %HP.size / Vector2(2.0,2.0)
	%HP.position = target_stat_position
	%HP.position.y -= (40 + simultaneous_position * default_movement)
	#to not cover stat value and not complicate position calc
	var target_color = Base.Green_color
	if stat_change_value < 0:
		target_color = Base.Red_color
	modulate = target_color
	%HP.text = str(abs(stat_change_value))
	
	#push_error("ready at " +str(global_position))
	var tween = create_tween().set_parallel(true)
	tween.tween_property(%HP, "self_modulate:a", 0, tween_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(%HP, "position:y", -100.0, tween_duration).as_relative().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
