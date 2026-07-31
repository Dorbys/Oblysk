extends Unit_passive_ability



func _ready():
	tower_layer.tuesday_phase_array.append(self)
	wielder.Ability1.text_for_tooltip = description
	
var description = "Tuesday: If there is a unit across, we strike each other"

func new_lane(new_tower_layer):
	if self not in tower_layer.tuesday_phase_array:
		new_tower_layer.tuesday_phase_array.append(self)

func tuesday_phase():
	await duel_opposer()
		
func duel_opposer():
	
	var opposer = await wielder.get_opposer(wielder.get_index())
	if opposer.TYPE == "unit" and wielder.HealthC > 0 and opposer.HealthC > 0 :
		var my_dmg = wielder.AttackC - opposer.ArmorC
		var opp_dmg = opposer.AttackC - wielder.ArmorC
		wielder.SMASH()
		await opposer.SMASH()
		#await get_tree().create_timer(Base.SMASH_animation_time).timeout
		
		opposer.take_damage(my_dmg)
		await get_tree().create_timer(Base.FAKE_DELTA).timeout 
		var died:bool = wielder.take_damage(opp_dmg)
		if died:
			await get_tree().create_timer(Base.visible_death_anim_length).timeout

		
	else:
		print("no heads to hunt were found")
		
	
