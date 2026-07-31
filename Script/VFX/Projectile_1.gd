extends VFX_class

@onready var scoping: AudioStreamPlayer2D = $Projectile/Scoping
@onready var awp: AudioStreamPlayer2D = $Projectile/Awp

var speed = 3000
var time_to_travel
var destination:Vector2 
var finished = false
	#to know when to deal damage

func _ready() -> void:
	#push_error("proj destination: " +str(destination))
	time_to_travel = calculate_time_to_travel()
	scoping.play()
	
func calculate_time_to_travel() -> float:
	var distance = global_position.distance_to(destination)
	return distance / speed

func _on_scoping_finished() -> void:
	awp.play()
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "global_position",destination,time_to_travel)
	await tween.finished
	visible = false
	finished = true

func _on_awp_finished() -> void:
	queue_free()
