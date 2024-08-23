extends Control



@onready var wielder = $"../.."
@onready var item_slot = $".."

var Item_ID
#given by unit when attaching this script to Item_base.tscn

var storage
#node in Item_base.tscn which contains COVERING and possibly other @export scenes
var COVERING


#STATS=====================================================
var cooldown
#given in ready()

#==========================================================

func _ready():
	item_slot.texture = Base.ITEM_TEXTURES[Item_ID]
	cooldown = ItemsDB.ITEMS_DB[Item_ID][ItemsDB.COOLDOWNPOSITION]
	item_slot.text_for_tooltip = "Cooldown(" +str(cooldown) + "): Teleport to chosen lane"
	item_slot.active_item_equipped(cooldown)
	#so that we can click the itemslot
	wielder.weapon_equipped = true
	storage = get_child(0)
	COVERING = storage.COVERING
	
	
func being_replaced(caller):
	item_slot.active_item_unequipped()
	item_slot.add_child(caller)
	self.queue_free()
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	

func item_clicked():
	item_slot.camera.camera_zoom_out()
	var another = COVERING.instantiate()
	another.origin_item = self
	another.Secondary_targets = Enums.Targeting.lane
	another.from_item = true
	another.target_faction = "alpha"
	another.Item_ID = Item_ID
	another.I_want_targets = 2
	wielder.UI_layer.add_child(another)
	wielder.already_a_target(another)
	
func activate_cooldown():
	item_slot.activate_cooldown()
	
	
	
	
	
	
	
	
	
