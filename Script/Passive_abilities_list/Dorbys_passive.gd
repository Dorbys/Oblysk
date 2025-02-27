extends Unit_passive_ability



var description = "SIEGE"

func _ready():
	wielder.Ability1.text_for_tooltip = description
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
	wielder.Siege = true
	wielder.increase_AttackM(0, 1)
	
	
	


func new_lane(_new_tower_layer):
	#should be in all passives regardless of their lane dependance
	pass
	
func remove_myself_from_old_array(old_tower_layer):
	#when I enter a new lane, I need to remove myself from the old one
	#dunno how to get this to class
	pass
