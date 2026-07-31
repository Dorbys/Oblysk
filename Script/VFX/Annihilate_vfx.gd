extends VFX_class

var particles

func _ready() -> void:
	if wielder.faction == "alpha":
		rotation = 192.0
	particles = [%Azure_flames, %White_flames, %Behind_rays]
	for particle in particles:
		particle.emitting = false
	#scale = Vector2(1.2,1.2)
	

func laser_max_length_reached():
	for i in particles.size():
		particles[i].emitting = true
	var tween = create_tween()
	tween.tween_property(wielder, "modulate", Color(0.2, 0.2, 0.3), 0.1)
	
	
func laser_finished():
	%Boom.play()
	if wielder:
		wielder.animating = false
		var tween = create_tween()
		tween.tween_property(wielder, "modulate", Color(1, 1, 1), 0.4)
	#push_error("null wielder")	
	await get_tree().create_timer(2).timeout
	queue_free()

func stop_emiting():
	for particle in particles:
		particle.emitting = false
