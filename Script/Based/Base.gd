extends Node



#pls dont do too many connections in base.gd
@onready var the_button
#THE_BUTTON declares itself this in it's _ready


var PLAYTEST = 0
#change to 1 to shuffle deck, set mana and XP, hide tech stuff,
#turns off alwayscaster
#you can play all units into enemy side
#Bombard building doesnt bombard






#Export doesnt let me load textures my way So I have to put them in manually
#IG?
var HERO_TEXTURES = [preload("res://Assets/CardsPNGS/Heroes/Acamar.png"),
preload("res://Assets/CardsPNGS/Heroes/Dorbys.png"),
preload("res://Assets/CardsPNGS/Heroes/Kajus.png"),
preload("res://Assets/CardsPNGS/Heroes/Kimmedi.png"),
preload("res://Assets/CardsPNGS/Heroes/Plott.jpg")]
#I guess this works :|
var SPELL_TEXTURES = [preload("res://Assets/CardsPNGS/Spells/Annihilation.jpg"),
preload("res://Assets/CardsPNGS/Spells/Bread.jpg"),
preload("res://Assets/CardsPNGS/Spells/Dorbystrike.jpg"),
preload("res://Assets/CardsPNGS/Spells/Duel.jpg"),
preload("res://Assets/CardsPNGS/Spells/Fate_of_the_weak.jpg"),
preload("res://Assets/CardsPNGS/Spells/hmmmmmmmmm.jpg"),
preload("res://Assets/CardsPNGS/Spells/My_peak.jpg"),
preload("res://Assets/CardsPNGS/Spells/SummonTwo.png"),
preload("res://Assets/CardsPNGS/Spells/Swap.jpg")]
var ICON_TEXTURES = [preload("res://Assets/CardsSMALLS/Acamar_small.png"),
preload("res://Assets/CardsSMALLS/Dorbys_small.png"),
preload("res://Assets/CardsSMALLS/Kajus_small.png"),
preload("res://Assets/CardsSMALLS/Kimmedi_small.png"),
preload("res://Assets/CardsSMALLS/Plott_small.jpg")]

var ITEM_TEXTURES = [preload("res://Assets/Items/Weapons/Blink_axe.jpg"),
preload("res://Assets/Items/Weapons/OBLYSK.png")]

var ABILITY_TEXTURES = [preload("res://Assets/CardsPNGS/Abilities/AcamarAbility.png"),
preload("res://Assets/CardsPNGS/Abilities/DorbysAbility.png"),
preload("res://Assets/CardsPNGS/Abilities/KajusAbility.png"),
preload("res://Assets/CardsPNGS/Abilities/KimmediAbility.png"),
preload("res://Assets/CardsPNGS/Abilities/PlottAbility.jpg")
]
var BUILDING_TEXTURES = [preload("res://Assets/CardsPNGS/Buildings/Acid11.png"),
preload("res://Assets/CardsPNGS/Buildings/Bombard.png"),
preload("res://Assets/CardsPNGS/Buildings/Drill.png"),
preload("res://Assets/CardsPNGS/Buildings/Gate.png")]
var BUILDINGS_SMALLS_TEXTURES = [preload("res://Assets/BuildingsSMALLS/Acid11.png"),
preload("res://Assets/BuildingsSMALLS/Bombard.png"),
preload("res://Assets/BuildingsSMALLS/Drill.png"),
preload("res://Assets/BuildingsSMALLS/Gate.png")]
var LVLUP_CARDS_TEXTURES = [preload("res://Assets/CardsPNGS/LVLUP_cards/Acamar_lvlup.jpg"),
preload("res://Assets/CardsPNGS/LVLUP_cards/Dorbys_lvlup.png"),
preload("res://Assets/CardsPNGS/LVLUP_cards/Kajus_lvlup.jpg"),
preload("res://Assets/CardsPNGS/LVLUP_cards/Kimmedi_lvlup.png"),
preload("res://Assets/CardsPNGS/LVLUP_cards/Plott_lvlup.png")
]
var CREEP_TEXTURES = [preload("res://Assets/CardsPNGS/Creeps/Golem.jpg"),
preload("res://Assets/CardsPNGS/Creeps/Hitman.jpg"),
preload("res://Assets/CardsPNGS/Creeps/Legionaire.png"),
preload("res://Assets/CardsPNGS/Creeps/Skelegone.png"),
preload("res://Assets/CardsPNGS/Creeps/Sommelier.png"),
preload("res://Assets/CardsPNGS/Creeps/Warbear.jpg"),
preload("res://Assets/CardsPNGS/Creeps/Zombie.png")]
var SPECIAL_TEXTURES = [preload("res://Assets/CardsPNGS/Special/Alpha_creep.png"),
preload("res://Assets/CardsPNGS/Special/Beta_creep.png")]
var CREEP_ABILITY_TEXTURES = [preload("res://Assets/CardsPNGS/Creep_abilities/Golem.jpg"),
preload("res://Assets/CardsPNGS/Creep_abilities/Hitman.jpg"),
preload("res://Assets/CardsPNGS/Creep_abilities/Legionaire.png"),
preload("res://Assets/CardsPNGS/Creep_abilities/Skelegone.png"),
preload("res://Assets/CardsPNGS/Creep_abilities/Sommelier.png"),
preload("res://Assets/CardsPNGS/Creep_abilities/Warbear.jpg"),
preload("res://Assets/CardsPNGS/Creep_abilities/Zombie.png")]
#currently stores alphacreep and betacreeep
var card = load("res://Scenes/UNIT/Unit1.tscn")
#var card = scene.instantiate()
var PlayerDeck =  [["spell",0],["spell",0],["spell",6],["spell",8],
	["spell",3],["creep",0],["creep",1],["build", 0],["item", 0]]
	
	
	
var playtest_deck = [
	["spell",0],["spell",1],["spell",3],["spell",4],["spell",5],
	["spell",6], ["creep",0],["creep",1],["creep",5],["build", 0],
	["spell",0],["spell",1],["spell",3],["spell",4],["spell",5],
	["spell",6], ["creep",0],["creep",1],["creep",5],["build", 0],
	["spell",0],["spell",1],["spell",3],["spell",4],["spell",5],
	["spell",8], ["creep",0],["creep",1],["creep",5],["build", 0],
	["spell",8],["spell",8],["spell",7],["spell",7],["spell",7]]

	
var index = PlayerDeck.find(["creep",0])
	
var HeroDeck = [1,4,2,3,0]
#DORBYS 	PLOTT 		KAJUS		KIMMEDI 	ACAMAR
#var HeroDeck = [1, 1 , 1, 1, 1,]
#this is copied over and reordered to OpponentDeck atm 
var OpponentHeroDeck = [0,3,1,4,2]

func swap_player_decks():
	#this will be replaced by sending playerdecks later on
	var temp = HeroDeck.duplicate()
	HeroDeck = []
	HeroDeck = OpponentHeroDeck.duplicate()
	OpponentHeroDeck = temp.duplicate()
	
var Player_heroes = []
#this array is appended by hero nodes 
#after they are initiated in arena during game start

var Opponent_heroes = []
#contains same heroes but unique nodes

var LAST_TOWER_HP = 23

var CARD_WIDTH = 216
var CARD_HEIGHT = 360

var FAKE_DELTA = 1/60.0
var FAKE_GAMMA = 1/42.0
var FAKE_OMEGA = 1/9.0
var MICRO_TIME = 1/240.0
#cuz nearsimultaneous shit

var Red_color = Color(250,0,0)
var Green_color = Color(0,250,0)
var Blue_color = Color(0,0,250)
var Black_color = Color(0,0,0)
var White_color = Color(1,1,1)
var Orange_color = Color(1, 0.6, 0)

var Combat_phase = 0
var CAN_CLICK_BUTTON_NOW = 1
#used for locking the pass button
#when its 1 button can be clicked, locking increases int by 1, unlocking decreases
var Main_phase = 0
#used for determining whether to use curving or rng_curving
#for unit gd   combat_damage_refresh
#determined by BUTTON

var current_lane =1
var viewed_lane = 1
#used for scrolling lanes

var LANE1_COORDINATES = Vector2(0,1600)
var LANE2_COORDINATES = Vector2(1930,1600)
var LANE3_COORDINATES = Vector2(3860,1600)
#var ZOOM_COORDINATES = Vector2(-110,844)
var ZOOM_COORDINATES = Vector2(-110,735)
#DONT USE THESE TWO TOGETHER
#set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)


var show_CIH_preview = true

var CIH_Y_OFFSET = 70
#kinda UNIT CIH had control on its top, I moved it, gotta make a new scene later

var aura_unique_id = 0
#used to give each aura source a unique number in their name (affect name and effect name)
#this allows auras to stack

func _ready():
	if PLAYTEST == 1:
		PlayerDeck= playtest_deck
		PlayerDeck.shuffle()
		
####################################SHUFFLE HERE
	

#	var dir = DirAccess.open("res://Assets/CardsPNGS/Heroes")
	
#	dir.list_dir_begin()
#	var file_name = dir.get_next()
#
#	while file_name.ends_with(".jpg") or file_name.ends_with(".png"):
#		var texture = load("res://Assets/CardsPNGS/Heroes/" + file_name)
#		HERO_TEXTURES.append(texture)
#		file_name = dir.get_next()
#		file_name = dir.get_next() 	#It's twice here ON PURPOSE cuz .import

		
	# One for UNIT TEXTURES , one for SPELL TEXTURES
#	var dir2 = DirAccess.open("res://Assets/CardsPNGS/Spells")
#	dir2.list_dir_begin()
#	var file_name2 = dir2.get_next()
#
#	while file_name2.ends_with(".jpg") or file_name2.ends_with(".png"):
#		var texture = load("res://Assets/CardsPNGS/Spells/" + file_name2)
#		SPELL_TEXTURES.append(texture)
#		file_name2 = dir2.get_next()
#		file_name2 = dir2.get_next() 	#It's twice here ON PURPOSE cuz .import
#
#	var dir3 = DirAccess.open("res://Assets/CardsSMALLS")
#	dir3.list_dir_begin()
#	var file_name3 = dir3.get_next()
#
#	while file_name3.ends_with(".jpg") or file_name3.ends_with(".png"):
#		var texture = load("res://Assets/CardsSMALLS/" + file_name3)
#		ICON_TEXTURES.append(texture)
#		file_name3 = dir3.get_next()
#		file_name3 = dir3.get_next() 	
		
#	var dir4 = DirAccess.open("res://Assets/Items/Weapons/")
#	dir4.list_dir_begin()
#	var file_name4 = dir4.get_next()
#
#	while file_name4.ends_with(".jpg") or file_name4.ends_with(".png"):
#		var texture = load("res://Assets/Items/Weapons/" + file_name4)
#		ITEM_TEXTURES.append(texture)
#		file_name4 = dir4.get_next()
#		file_name4 = dir4.get_next() 	
#
#	var dir5 = DirAccess.open("res://Assets/CardsPNGS/Abilities/")
#	dir5.list_dir_begin()
#	var file_name5 = dir5.get_next()
#
#	while file_name5.ends_with(".jpg") or file_name5.ends_with(".png"):
#		var texture = load("res://Assets/CardsPNGS/Abilities/" + file_name5)
#		ABILITY_TEXTURES.append(texture)
#		file_name5 = dir5.get_next()
#		file_name5 = dir5.get_next() 	
		
#	var dir6 = DirAccess.open("res://Assets/CardsPNGS/Buildings/")
#	dir6.list_dir_begin()
#	var file_name6 = dir6.get_next()
#
#	while file_name6.ends_with(".jpg") or file_name6.ends_with(".png"):
#		var texture = load("res://Assets/CardsPNGS/Buildings/" + file_name6)
#		BUILDING_TEXTURES.append(texture)
#		file_name6 = dir6.get_next()
#		file_name6 = dir6.get_next() 		
#
#	var dir7 = DirAccess.open("res://Assets/BuildingsSMALLS/")
#	dir7.list_dir_begin()
#	var file_name7 = dir7.get_next()
#
#	while file_name7.ends_with(".jpg") or file_name7.ends_with(".png"):
#		var texture = load("res://Assets/BuildingsSMALLS/" + file_name7)
#		BUILDINGS_SMALLS_TEXTURES.append(texture)
#		file_name7 = dir7.get_next()
#		file_name7 = dir7.get_next() 			
		
#	var dir8 = DirAccess.open("res://Assets/CardsPNGS/LVLUP_cards")
#	dir8.list_dir_begin()
#	var file_name8 = dir8.get_next()
#
#	while file_name8.ends_with(".jpg") or file_name8.ends_with(".png"):
#		var texture = load("res://Assets/CardsPNGS/LVLUP_cards/" + file_name8)
#		LVLUP_CARDS_TEXTURES.append(texture)
#		file_name8 = dir8.get_next()
#		file_name8 = dir8.get_next()
#
#	var dir9 = DirAccess.open("res://Assets/CardsPNGS/Creeps")
#	dir9.list_dir_begin()
#	var file_name9 = dir9.get_next()
#
#	while file_name9.ends_with(".jpg") or file_name9.ends_with(".png"):
#		var texture = load("res://Assets/CardsPNGS/Creeps/" + file_name9)
#		CREEP_TEXTURES.append(texture)
#		file_name9 = dir9.get_next()
#		file_name9 = dir9.get_next()
#
#	var dir10 = DirAccess.open("res://Assets/CardsPNGS/Special")
#	dir10.list_dir_begin()
#	var file_name10 = dir10.get_next()
#
#	while file_name10.ends_with(".jpg") or file_name10.ends_with(".png"):
#		var texture = load("res://Assets/CardsPNGS/Special/" + file_name10)
#		SPECIAL_TEXTURES.append(texture)
#		file_name10 = dir10.get_next()
#		file_name10 = dir10.get_next()
#
#	var dir11 = DirAccess.open("res://Assets/CardsPNGS/Creep_abilities")
#	dir11.list_dir_begin()
#	var file_name11 = dir11.get_next()
#
#	while file_name11.ends_with(".jpg") or file_name11.ends_with(".png"):
#		var texture = load("res://Assets/CardsPNGS/Creep_abilities/" + file_name11)
#		CREEP_ABILITY_TEXTURES.append(texture)
#		file_name11 = dir11.get_next()
#		file_name11 = dir11.get_next()
#
		
func move_to_next_lane():
	current_lane +=1
	if current_lane == 5:
		current_lane = 1		
		
		
		
		
		
		
		

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			show_CIH_preview = false
			await get_tree().create_timer(Base.FAKE_DELTA).timeout 
			show_CIH_preview = true		
		
	#Twice cuz this one should load ALL the cards in game
#	var GIVEN_ID = 0 		#Well I can just make list with the IDs LOL
#	for i in UNIT_STATS:	#in python again btw
#		i.append(GIVEN_ID)
#		GIVEN_ID += 1
#		print(i)

#	for FakeID in PlayerDeck:		
#		#This function is useless, no idea why I wrote it
#		print(FakeID)
#		var another = card.instantiate()
#		another.Unit_Name = UNIT_STATS[FakeID][NAMEPOSITION]
#		#another.Unit_Pfp = UNIT_TEXTURES[FakeID]
#		another.Unit_Attack = UNIT_STATS[FakeID][ATTACKPOSITION]
#		another.Unit_Health = UNIT_STATS[FakeID][HEALTHPOSITION]
#		# This is how to get the highest node of your tree
#		(get_tree().get_root().get_children()[0]).add_child(another)




func lock_pass_button():
	CAN_CLICK_BUTTON_NOW += 1
	the_button.set_disabled(true)
	
func unlock_pass_button(forced = false):
	if forced == true:
		CAN_CLICK_BUTTON_NOW = 1
		the_button.set_disabled(false)
	else:
		CAN_CLICK_BUTTON_NOW -= 1
		if CAN_CLICK_BUTTON_NOW == 1:
			the_button.set_disabled(false)





func increase_aura_unique_id():
	aura_unique_id += 1




#I'm taking care of this in python so that it is in alphabetical order

	





