extends ColorRect


@onready var hand_rect = $"../../../../../../UI_layer/SCROLLH/HANDA/SIZECHECK/HandRect"
@onready var card_layer = $"../../../.."
@onready var JustArena = $"../../../../SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var MYrena_rect = $"../ArenaRect"
@onready var MYrena_mid = $"../ArenaMid"
@onready var tower_mana = $"../../../../../Tower_layer/TowerA/Mana_display/Current_mana"



var my_lane:int 
#stolen from MYrena_rect during ready

var my_tower_buildings

func _ready():
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 

	if MYrena_rect.MY_identity == "A":
		my_tower_buildings = $"../../../../../Tower_layer/TowerA/Buildings"
	elif MYrena_rect.MY_identity == "B":
		my_tower_buildings = $"../../../../../Tower_layer/TowerB/Buildings"
	######################3 HERE WE DO A LITTLE TROLLING FOR NOW 
		#wut?
				
		
	else: push_error("MYrenaRect has OP identity crisis i guess")
	
	my_lane = MYrena_rect.my_lane
#	print("roofs mylane is: " +str(my_lane))
	
	
func _can_drop_data(_at_position, DropData):
	if my_lane == Base.current_lane or (DropData[0] == 1 and DropData[3] == true):
		return true
	else:
		return false

		
func _drop_data(at_position, DropData):
	#DROPDATE THESE: 
	#[controlor.TYPE, controlor.Identification, 
	#controlor.get_index(), has_ability ]
	if DropData[0] == "unit":
		MYrena_rect.Carrying = 0
		#creates the unit
		MYrena_rect.Adding_Units(at_position, DropData[1])
		#spends mana
#		tower_mana.spend_mana(CreepsDB.CREEPS_DB[DropData[1]][CreepsDB.COSTPOSITION])
		#removes the card
		hand_rect.used_card(DropData[2])
		#isnt removed via hand_rect.used_card() because unit xp not implemented 
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		hand_rect.collide_cards()
		
	elif DropData[0] == "spell" or DropData[0] == "lvlup_spell":
		#DROPDATA SPELL1 THESE: 
		#[0= TYPE, 1=Identification, 2=self.get_index(), 
		#3=crosslane, 4=Card_from_lvlup, 5= Secondary_targets
		#6 = Targets #7 = current player]
		var DB = SpellsDB
		var DBList = SpellsDB.SPELLS_DB
		if DropData[0] == "lvlup_spell":
			DB = LvlupDB
			DBList = LvlupDB.LVLUPS_DB
		var which_function:String = str(DBList[DropData[1]][DB.NAMEPOSITION])
		if Lobby.MULTIPLAYER == true:
			drop_data_multiplayer_funcall(DropData[0],which_function, DropData[7])
		else:
			DB.call(which_function, MYrena_rect)
			
		hand_rect.used_card(DropData[2])
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		hand_rect.collide_cards()
		
		
	elif DropData[0] == "building":
		if Lobby.MULTIPLAYER == true:
			card_layer.make_mirror_lane_building(DropData[1])
		my_tower_buildings.make_building(DropData[1])
		
		hand_rect.used_card(DropData[2])
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		hand_rect.collide_cards()
		
	else: 
		print("unknown card dropped in ArenaRoof")
#		print(str(DropData[6]))
		


func drop_data_multiplayer_funcall(spelltype:String, function_to_be_called:String, current_player:String):
	#can only be called if MP yes
	#handles that join gets the function first, 
		#since curving can't be fucked from there
	var DB = SpellsDB
	if spelltype == "lvlup_spell":
		DB = LvlupDB

	DB.call(function_to_be_called,MYrena_rect,current_player)
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	card_layer.make_mirror_lane_receive_spell_call(spelltype, function_to_be_called, current_player)
