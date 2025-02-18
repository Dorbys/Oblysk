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

var ITEMS_DB = [["Blink_axe", 1, -1,2],["Oblysk", 1, -1, 0]]




func Blink_axe(blinker, destination):
	blinker.pull_me_out_of_this_lane()
	destination.land_here(blinker)
		#who's landing and from where
	









var Blink_axe_description = "ACTIVE: Select a lane, teleport me to random empty combat slot in it"
var Oblysk_description = "Wielder: +5 Attack"
#number here to be extracted from respective scripts

