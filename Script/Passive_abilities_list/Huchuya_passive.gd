extends Unit_passive_ability



func _ready():
	tower_layer.cleanup_phase_array.append(self)
	

func new_lane(new_tower_layer):
	new_tower_layer.cleanup_phase_array.append(self)

func cleanup_phase():
	Skillet()
		
func Skillet():
	wielder.increase_AttackM(1, 1)
		
	
