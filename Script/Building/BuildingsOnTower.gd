extends Control

@onready var card_layer = $"../../../Card_layer"

func refresh_aura(target,faction,wielder):
	var population = get_child_count()
	for i in population:
		var house = get_child(i)
		
		if house.is_aura == true and house.do_I_affect_faction(faction) == true:
			house.affect_unit(target,wielder)
		await get_tree().create_timer(Base.MICRO_TIME).timeout

#		else: print(house.is_aura)
#		print(house.do_I_affect_faction(faction))


func _on_child_exiting_tree(_node):
	card_layer.lane_aura_check_both()
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	collide_buildings()
	
func collide_buildings():
	var collide_time = 0.4
	var population = get_child_count()
	var tween = create_tween().set_parallel(true)
	for i in range(population-1 , -1, -1):
#		get_child(i).position.x = 50 + (i * 110)
		tween.tween_property(get_child(i),"position:x",50 + (i * 110), collide_time)

	
	
	
	
	
	
	
	
	
	
	
	
