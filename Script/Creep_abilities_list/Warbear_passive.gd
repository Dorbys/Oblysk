extends Unit_passive_ability



var ATTACK = 3
var HEALTH = 0

var description = "Friday: +" +str(ATTACK) + " attack"#"/" +str(HEALTH)

func _ready():
	wielder.Ability1.text_for_tooltip = description
	tower_layer.friday_phase_array.append(self)
	
	

func new_lane(new_tower_layer):
	if self not in tower_layer.friday_phase_array:
		new_tower_layer.friday_phase_array.append(self)

func friday_phase():
	Warmarch()
		
func Warmarch():

	wielder.increase_AttackM(ATTACK, 1)
	#wielder.increase_HealthM(HEALTH, 1)
	
