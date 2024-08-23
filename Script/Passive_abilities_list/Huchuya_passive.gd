extends Control

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

func _ready():
	tower_layer.cleanup_phase_list.append(self)
	

func new_lane(new_tower_layer):
	new_tower_layer.cleanup_phase_list.append(self)

func cleanup_phase():
	Skillet()
		
func Skillet():
	wielder.increase_AttackM(1, 1)
		
	
