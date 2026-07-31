extends Building_passive_ability


var op_tower

var DAMAGE = 6
var INCREMENT = 3



func _ready():
	get_parent().text_for_tooltip = "Monday: deal " +str(DAMAGE) + " damage to enemy tower.
and increase this damage by "	+ str(INCREMENT)
	tower_layer.monday_phase_array.append(self)
	op_tower = BUTTON.towerA2
	projectile = load("uid://yqqb5b6leogi")
	custom_projectile_texture = load("uid://cf7h1bk5abb6a")

func new_lane(new_tower_layer):
	if self not in new_tower_layer.monday_phase_array:
		new_tower_layer.monday_phase_array.append(self)

func monday_phase():
	await Drilling()
		
func Drilling():
	await projectile_animation(house.visual_center, op_tower.visual_center)
	op_tower.take_damage(DAMAGE)
	DAMAGE += INCREMENT
	get_parent().text_for_tooltip = "Monday: deal " +str(DAMAGE) + " damage to enemy tower.
and increase my damage by " +str(INCREMENT)
	return 0
		

	
