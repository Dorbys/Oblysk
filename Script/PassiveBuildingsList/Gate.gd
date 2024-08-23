extends Node


@onready var BUTTON = $"../../../../../../UI_layer/THE_BUTTON"
@onready var tower_layer = $"../../../../"


var my_lane
func _ready():
	get_parent().text_for_tooltip = "Friday: spawn a 3/1 zombie"
	tower_layer.friday_phase_list.append(self)
	tower_layer.VIP_list.append(self)
	#to exlude me from Unit checks
	my_lane = BUTTON.abarena_rect3
	

func new_lane(new_tower_layer):
	if self not in new_tower_layer.friday_phase_list:
		new_tower_layer.friday_phase_list.append(self)

func friday_phase():
	Gating()
		
func Gating():
	my_lane.spawn_unit(6)
