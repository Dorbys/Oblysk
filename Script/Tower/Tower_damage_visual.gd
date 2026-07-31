extends VFX_class

@onready var health_change_label: Label = %Health_change_label


var health_change_value:int
	#given by caller
		
var simultaneous_position:int
	#given by caller
	#moves me up, to not cover simultaneous myselfs 	
	
var tween_duration = 1.2

var default_movement = 50
	#I need to get above(y) the stat label I explain and above(y) other SCAs
	
func _ready() -> void:
	health_change_label.position.y -= simultaneous_position * default_movement
	#to not cover stat value and not complicate position calc
	var target_color = Base.Red_color
	if health_change_value < 0:
		target_color = Base.Green_color
	modulate = target_color
	health_change_label.text = str(abs(health_change_value))
	
	#push_error("ready at " +str(global_position))
	var tween = create_tween().set_parallel(true)
	tween.tween_property(health_change_label, "self_modulate:a", 0, tween_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(health_change_label, "position:y", -100.0, tween_duration).as_relative().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
