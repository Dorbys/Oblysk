extends Control

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

var ATTACK = 2
var HEALTH = 1

var description = "Friday: +" +str(ATTACK) + "/" +str(HEALTH)

func _ready():
	wielder.Ability1.text_for_tooltip = description
	tower_layer.friday_phase_list.append(self)
	
	

func new_lane(new_tower_layer):
	if self not in tower_layer.friday_phase_list:
		new_tower_layer.friday_phase_list.append(self)

func friday_phase():
	Warmarch()
		
func Warmarch():
	wielder.increase_AttackM(2, 1)
	wielder.increase_HealthM(1, 1)
	
