extends Unit_passive_ability



func _ready():
	tower_layer.monday_phase_list.append(self)

func new_lane(new_tower_layer):
	new_tower_layer.monday_phase_list.append(self)

func monday_phase():
	find_new_head()
		
func find_new_head():
	
	#nah bruh, both useless and messes up curving
	
	
	if await wielder.get_opposer(wielder.get_index()).TYPE != "unit":
		var arena = wielder.MYrena_rect
		var population = arena.get_child_count()
		var empty_voids = []
		for i in population:
			var target = arena.get_child(i)
			if target.TYPE == "void":
				empty_voids.append(target.get_index())
		var voidcount = len(empty_voids)
		if voidcount > 0:
			var gamba = randi()%voidcount
			arena.swap_children(wielder.get_index(),empty_voids[gamba])
		else:
			push_error("no new heads to hunt were found")
		
	
