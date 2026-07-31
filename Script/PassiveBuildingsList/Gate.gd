extends Building_passive_ability


var my_lane

func _ready():
	get_parent().text_for_tooltip = "Friday: spawn a 4/1 zombie"
	tower_layer.friday_phase_array.append(self)
#	tower_layer.VIP_array.append(self)
	#to exlude me from Unit checks
	my_lane = BUTTON.abarena_rect3
	

func new_lane(new_tower_layer):
	if self not in new_tower_layer.friday_phase_array:
		new_tower_layer.friday_phase_array.append(self)

func friday_phase():
	await gate()
		
func gate():
	await my_lane.spawn_unit(6, 1)
	house.play_sfx("spell", "Summon_two")
