extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	if Base.PLAYTEST == 1:
		self.play()
