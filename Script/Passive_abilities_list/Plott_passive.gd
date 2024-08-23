extends Control

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

var XP = 2
var description = "Monday: +" +str(XP) + " XP"

func _ready():
	wielder.Ability1.text_for_tooltip = description
	tower_layer.monday_phase_list.append(self)
	

func new_lane(new_tower_layer):
	if self not in new_tower_layer.monday_phase_list:
		new_tower_layer.monday_phase_list.append(self)

func monday_phase():
	Teaching()
		
func Teaching():
	wielder.XP_panel.increase_xp(XP) 
		
	
