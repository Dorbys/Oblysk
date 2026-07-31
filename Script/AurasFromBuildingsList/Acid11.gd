extends Node

@onready var wielder = $"../../.."

# Called when the node enters the scene tree for the first time.

var CHECKED = false
#used for updating lane auras, needs to be in each aura
var aura_unique_id
#used for differentieting sources of auras and allowing them to stack

var debuff_name = "Acid11"



var armor = -1
func _ready():
	while wielder.readied == false:
		push_error("awaiting readying of wielder")
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
	
	wielder.increase_ArmorM(armor,true)
	wielder.debuff_applied_animation()
	if Base.spammable_sfx.has(debuff_name):
		pass
	else:
		Base.spammable_sfx.append(debuff_name)
		var my_sfx = load("res://Assets/Sounds/SFX/Buffs/Acid11.mp3")
		wielder.play_spammable_sfx(my_sfx,debuff_name)
		
	#push_error("Acid11 afflicted: " +str(name) + str(aura_unique_id))


func get_removed():
	await wielder.increase_ArmorM(-armor,true)
	push_error("Acid11 is leaving")
	self.queue_free()
