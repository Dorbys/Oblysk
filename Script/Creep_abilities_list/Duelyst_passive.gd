extends Control

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

func _ready():
	tower_layer.tuesday_phase_list.append(self)
	wielder.Ability1.text_for_tooltip = description
	
var description = "Tuesday: If there is a unit across, we strike each other"

func new_lane(new_tower_layer):
	if self not in tower_layer.tuesday_phase_list:
		new_tower_layer.tuesday_phase_list.append(self)

func tuesday_phase():
	duel_opposer()
		
func duel_opposer():
	
	#nah bruh, both useless and messes up curving
	
	var opposer = await wielder.get_opposer(wielder.get_index())
	if opposer.TYPE == 0 and opposer.HealthC > 0:
		var my_dmg = wielder.AttackC - opposer.ArmorC
		var opp_dmg = opposer.AttackC - wielder.ArmorC
		
		opposer.take_damage(my_dmg)
		await get_tree().create_timer(Base.FAKE_DELTA).timeout 
		wielder.take_damage(opp_dmg)
		
	else:
		print("no heads to hunt were found")
		
	
