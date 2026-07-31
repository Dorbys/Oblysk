extends Unit_passive_ability



var ATTACK = 2
var HEALTH = 1

var description = "Friday: +" +str(ATTACK) + "/" +str(HEALTH)
func _ready():
	wielder.Ability1.text_for_tooltip = description
	tower_layer.friday_phase_array.append(self)
	

func new_lane(new_tower_layer):
	if self not in tower_layer.friday_phase_array:
		new_tower_layer.friday_phase_array.append(self)

func friday_phase():
	Warmarch()
		
func Warmarch():
	wielder.buff_applied_animation()
	wielder.increase_AttackM(2, true)
	wielder.increase_HealthM(1, true)	
	
