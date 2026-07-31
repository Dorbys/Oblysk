extends VFX_class


var speed = 1800
var time_to_travel
var destination:Vector2 
var finished = false
	#to know when to deal damage

func _ready() -> void:
	#push_error("proj destination: " +str(destination))
	time_to_travel = calculate_time_to_travel()
	launch()
	
func calculate_time_to_travel() -> float:
	var distance = global_position.distance_to(destination)
	return distance / speed

func launch() -> void:
	visible = true
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position",destination,time_to_travel)
	tween.tween_property(%Bones, "rotation", 3600,time_to_travel).as_relative()
	await tween.finished
	visible = false
	finished = true
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout
	queue_free()

	
