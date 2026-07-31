extends Node

var WEAPONSLOT = 1
var SPECIALSLOT = 2
var ARMORSLOT = 3





var NAMEPOSITION = 0
var ITEMMPOSITION = 1
#KEEP ITEMMPOSITION SAME AS SLOTS
#var STATPOSITION = 2
var COSTPOSITION = 2
var COOLDOWNPOSITION = 3


var ITEMS_DB = [
	["Blink_axe", 2, -1,2],
	["Oblysk", 2, -1, 0]]


func get_cooldown(item_name: String):
	for item in ITEMS_DB:
		if item[NAMEPOSITION] == item_name:
			return str(item[COOLDOWNPOSITION])
	push_error("Item " +str(item_name) + " not found in ITEMS_DB")
	return "-1"

func Blink_axe(blinker, destination, forced_slot, _rpced = false):
	#forced slot aquired through sync_data
	if _rpced == true:
		destination = destination.abarena
	var landing_slot:int
	await blinker.pull_me_out_of_this_lane()
	landing_slot = await destination.land_here(blinker, forced_slot)
		#who's landing and from where
	var movement_sfx = load("res://Assets/Sounds/SFX/Movement.mp3")
	blinker.play_spammable_sfx(movement_sfx, "movement")
	push_error(blinker.Unit_Name + " is landing at: " +str(landing_slot))
	return landing_slot







#cooldown = ItemsDB.ITEMS_DB[Item_ID][ItemsDB.COOLDOWNPOSITION]
	#item_slot.text_for_tooltip = "Cooldown(" +str(cooldown) + "): Teleport to chosen lane"

var Blink_axe_description = "Cooldown(" + get_cooldown("Blink_axe") + "): Teleport to a random combat slot in the chosen lane"
var Oblysk_description = "Wielder: +5 Attack"
#number here to be extracted from respective scripts
