extends TextureRect


var curving_time = 0.3
var c_angle = 25
var c_distance = 108
var basex = 78

func _ready():
	var wielder = $"../.."
	#check if I'm in abarena
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 

	if wielder.MYrena_rect.OP_identity == 0:
		c_angle = -c_angle
		reposition_down()
		
func reposition_down():
	position.y = 360
	flip_v = true
	
func curve_straight():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 0, curving_time)
	tween.tween_property(self, "position:x", basex, curving_time)
	
func curve_left():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "rotation_degrees", -c_angle, curving_time)
	tween.tween_property(self, "position:x", basex-c_distance, curving_time)
		
func curve_right():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "rotation_degrees", c_angle, curving_time)
	tween.tween_property(self, "position:x", basex+c_distance, curving_time)
	
	
	
	
	
	
