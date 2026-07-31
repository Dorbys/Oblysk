extends Control
@onready var wielder = $"../.."

func reupdate(faction):
	#if wielder.card_layer != null:
		#push_error("reupdating with: " +str(get_child_count()))
		var population = get_child_count()
		for i in population:
			get_child(i).CHECKED = false
			
	#	print("faction is: " +str(faction))
			
		await get_tree().create_timer(Base.FAKE_DELTA).timeout 

		await wielder.card_layer.refresh_lane_auras(self,faction, wielder)
		
		for i in range(population - 1, -1, -1):
	#		push_error("reupdating at " +str(i))
			if get_child(i).CHECKED == false:
				get_child(i).get_removed()
	#else:
		#push_error("attempted to reach card layer from Lane_auras 
		#before unit has a card layer assigned")
	





#func _on_child_exiting_tree(node):
#	push_error("somebody is stealing this aura " +str(node.name))
