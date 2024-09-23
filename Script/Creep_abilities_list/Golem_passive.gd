extends Control

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

var description = "Entrance: Increase my attack by attack of my left neighbour"

func _ready():
	wielder.Ability1.text_for_tooltip = description
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
	

	var index = wielder.get_index()
	if index > 0:
		var target = wielder.MYrena_rect.get_child(index-1)
		if target.TYPE == 0:
			wielder.increase_AttackM(target.AttackM,1)
	

func new_lane(_new_tower_layer):
	#currently just because all passives must have this
	pass


		
	
