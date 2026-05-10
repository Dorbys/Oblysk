extends Control



class_name  Unit_passive_ability

var TYPE = "unit_passive_ability"
	#just because TYPE will be compared in Signal_Hub

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

func wait_for_wielder_to_be_readied():
	var attempts = 30
	while wielder.readied == false:
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		attempts -= 1
		if attempts == 0:
			push_error("attempts depleted")
			break

	
