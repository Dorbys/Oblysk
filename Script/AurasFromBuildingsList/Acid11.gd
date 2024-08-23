extends Node

@onready var wielder = $"../../.."

# Called when the node enters the scene tree for the first time.

var CHECKED = false
#used for updating lane auras, needs to be in each aura
var aura_unique_id
#used for differentieting sources of auras and allowing them to stack





var armor = -1
func _ready():
	wielder.increase_ArmorM(armor,1)

	print("Acid11 afflicted: " +str(name) + str(aura_unique_id))


func get_removed():
	wielder.increase_ArmorM(-armor,1)
	print("Acid11 is leaving")
	self.queue_free()
