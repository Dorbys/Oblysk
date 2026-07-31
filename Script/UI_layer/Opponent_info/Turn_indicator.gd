extends TextureRect


#from gemini


# Rotation speed in radians per second
@export var rotation_speed: float
@export var active_texture: Texture
@export var inactive_texture: Texture

var current_angle: float = 0.0
var active = false

# Called when the node enters the scene tree for the first time.

func active_texture_now():
#	push_error("setting in Turn indic")
	texture = active_texture
	active = true
	
func inactive_texture_now():
	texture = inactive_texture
	active = false

func _process(delta: float):
	if active == true:
		# 1. Update the angle over time
		current_angle += rotation_speed * delta
		
		# 2. Define the gradient's center point (e.g., the center of the texture)
		var center = Vector2(0.5, 0.5)

		# 3. Define the length of the gradient line (e.g., 0.5 units from center)
		var length: float = 0.5 

		# 4. Calculate the new rotated points using trigonometry
		# sin() and cos() are used to calculate the point on a circle
		var new_offset = Vector2(cos(current_angle), sin(current_angle)) * length
		
		# 5. Set the new fill vectors
		# Start point is center - offset, End point is center + offset
		texture.fill_from = center - new_offset
		texture.fill_to = center + new_offset
	
