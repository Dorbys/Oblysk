extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	print("No mana bro")
	var warmup_time = 0.25
	var warning_time = 0.5
	await get_tree().create_timer(warmup_time).timeout 
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a",0,warning_time)
	await get_tree().create_timer(warning_time).timeout 
	self.queue_free()
