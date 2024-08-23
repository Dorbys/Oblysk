extends ScrollContainer

var prep_time = 0.25
var charge_time = 0.1
var back_time = 0.4



func SMASH():
	var x = self.position.x
	var y = self.position.y
	var prep_distance = 210
	var charge_distance = 240
	#var rest_distance = charge_distance - prep_distance
	#make a tween for animation:
	var tween = get_tree().create_tween()
	#we tween property 	of what 	which one 	to what 			how much time
	tween.tween_property(self, "position", Vector2(x,y+prep_distance), prep_time)
	tween.tween_property(self, 
	"position", Vector2(x,y+prep_distance-charge_distance), charge_time)
	tween.tween_property(self, "position", Vector2(x,y), back_time)
	


