extends Control

@export var Item_attack = 0
@export var Item_health = 0
@export var Item_armor = 0
@export var Item_resist = 0
@onready var wielder = $"../.."
@onready var item_slot = $".."

# Called when the node enters the scene tree for the first time.

var Item_ID

#STATS=====================================================
var Damage = 3
#==========================================================

func _ready():
	item_slot.texture = Base.ITEM_TEXTURES[Item_ID]
	item_slot.text_for_tooltip = "+ " +str(Damage) +" attack"
	item_slot.item_equipped()
	
	wielder.weapon_equipped = true
	wielder.increase_AttackM(Damage, 1)
	
func being_replaced(caller):
	wielder.increase_AttackM(-Damage, 1)
#	item_slot.texture=null
	item_slot.add_child(caller)
	self.queue_free()
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	


