extends Unit_passive_ability



var description = "Entrance: Increase my attack by attack of my left neighbour"

func _ready():
	wielder.Ability1.text_for_tooltip = description
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
	

	var index = wielder.get_index()
	if index > 0:
		var target = wielder.MYrena_rect.get_child(index-1)
		if target.TYPE == "unit":
			var target_atk = target.AttackM
			if target_atk > 0:
				await wait_for_wielder_to_be_readied()
				wielder.buff_applied_animation()
				wielder.increase_AttackM(target_atk,1)
	

func new_lane(_new_tower_layer):
	#currently just because all passives must have this
	pass


		
	
