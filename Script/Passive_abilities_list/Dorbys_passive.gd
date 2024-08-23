extends Control

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

var description = "SIEGE"

func _ready():
	wielder.Ability1.text_for_tooltip = description
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
	wielder.Siege = true
	wielder.increase_AttackM(0, 1)
	
	
	


func new_lane(_new_tower_layer):
	#should be in all passives regardless of their lane dependance
	pass
