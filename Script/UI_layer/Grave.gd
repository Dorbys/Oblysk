extends TextureRect
@onready var graveyard_showcase = $"../../../.."

var r_time = 0
var green = Color(1, 2, 1, 1)
var red = Color(2, 1, 1, 1)

func r_update():
	if r_time > 0:
		r_time -= 1
	
		if r_time == 0:
			await graveyard_showcase.respawn(self, self.get_child(0))
			self.texture = null
		elif r_time == 1:
			self.modulate = green
		elif r_time == 2:
			self.modulate = red
		else:
			push_error("UNKNOWN r_time VALUEID: " +str(r_time)  +str(self.get_index()))
		
