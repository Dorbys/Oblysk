extends Control

@onready var tower_layer = $"../../../../"
@onready var BUTTON = $"../../../../../../UI_layer/THE_BUTTON"
var op_tower

var DAMAGE = 6

func _ready():
	get_parent().text_for_tooltip = "Monday: deal " +str(DAMAGE) + " damage to enemy tower.
and increase my damage by 3"	
	tower_layer.monday_phase_list.append(self)
	tower_layer.VIP_list.append(self)
	op_tower = BUTTON.towerA2
	

func new_lane(new_tower_layer):
	if self not in new_tower_layer.monday_phase_list:
		new_tower_layer.monday_phase_list.append(self)

func monday_phase():
	Drilling()
		
func Drilling():
	op_tower.take_damage(DAMAGE)
	DAMAGE += 3
	get_parent().text_for_tooltip = "Monday: deal " +str(DAMAGE) + " damage to enemy tower.
and increase my damage by 3"
		
	
