extends ColorRect


@onready var hand_rect = $"../../../../../../UI_layer/SCROLLH/HANDA/SIZECHECK/HandRect"

@onready var JustArena = $"../../../../SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var MYrena_rect = $"../ArenaRect"
@onready var MYrena_mid = $"../ArenaMid"
@onready var tower_mana = $"../../../../../Tower_layer/TowerA/Mana_display/Current_mana"

@export var BUILDING_SCENE: PackedScene

var my_lane
#stolen from MYrena_rect during ready

var my_tower_buildings

func _ready():
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 

	if MYrena_rect.OP_identity == 1:
		my_tower_buildings = $"../../../../../Tower_layer/TowerA/Buildings"
	elif MYrena_rect.OP_identity == 0:
		my_tower_buildings = $"../../../../../Tower_layer/TowerA/Buildings"
	######################3 HERE WE DO A LITTLE TROLLING FOR NOW 
				
		
	else: print("MYrenaRect has OP identity crisis i guess")
	
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
	if DropData[0] == 0:
		MYrena_rect.Carrying = 0
		#creates the unit
		MYrena_rect.Adding_Units(at_position, DropData[1], DropData[3])
		#spends mana
#		tower_mana.spend_mana(CreepsDB.CREEPS_DB[DropData[1]][CreepsDB.COSTPOSITION])
		#removes the card
		hand_rect.used_card(DropData[2])
		#isnt removed via hand_rect.used_card() because unit xp not implemented 
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		hand_rect.collide_cards()
		
	elif DropData[0] == 1 and DropData[6] == "Lane":
		#DROPDATA SPELL1 THESE: 
		#[0= TYPE, 1=Identification, 2=self.get_index(), 
		#3=crosslane, 4=Card_from_lvlup, 5= Secondary_targets
		#6 = Targets]
		

		SpellsDB.call(str(SpellsDB.SPELLS_DB[DropData[1]][SpellsDB.NAMEPOSITION]),
		JustArena)
		############################################# JUST ARENA ########
		#Resolves the spell
#		tower_mana.spend_mana(SpellsDB.SPELLS_DB[DropData[1]][SpellsDB.COSTPOSITION])		
		#Spends mana
		#MOVING THIS TO CARD USED
		hand_rect.used_card(DropData[2])
		#removes the card
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		hand_rect.collide_cards()
	
	elif DropData[0] == 11 and DropData[6] == "Lane":
		#DROPDATA SPELL1 THESE: 
		#[0= TYPE, 1=Identification, 2=self.get_index(), 
		#3=crosslane, 4=Card_from_lvlup, 5= Secondary_targets
		#6 = Targets]
		

		LvlupDB.call(str(LvlupDB.LVLUPS_DB[DropData[1]][LvlupDB.NAMEPOSITION]),
		MYrena_rect)
		#Resolves the spell
#		tower_mana.spend_mana(LvlupDB.LVLUPS_DB[DropData[1]][LvlupDB.COSTPOSITION])		
		#Spends mana
		hand_rect.used_card(DropData[2])
		#removes the card
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		hand_rect.collide_cards()
		
	elif DropData[0] == 3:
		var house = BUILDING_SCENE.instantiate()
		house.Build_name = BuildDB.BUILD_DB[DropData[1]][BuildDB.NAMEPOSITION]
		house.Build_Pfp = Base.BUILDINGS_SMALLS_TEXTURES[DropData[1]]
#		house.Card_Cost = BuildDB.BUILD_DB[DropData[1]][BuildDB.COSTPOSITION]
#		house.Build_XP = BuildDB.BUILD_DB[DropData[1]][BuildDB.XPPOSITION]
		house.is_aura = BuildDB.BUILD_DB[DropData[1]][BuildDB.ISAURAPOSITION]
		house.affects = BuildDB.BUILD_DB[DropData[1]][BuildDB.AFFPOSITION]
#		house.Identification = DropData[1]
		house.position.x = 50+ my_tower_buildings.get_child_count() * 110
		#For now placement
		my_tower_buildings.add_child(house)
		
		hand_rect.used_card(DropData[2])
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		hand_rect.collide_cards()
		
	else: 
		print("unknown card dropped in ArenaRoof")
#		print(str(DropData[6]))
		
#	if DropData[0] == 1:
#		MYrena_rect.TargetingSpell = 0
#		MYrena_rect.ResolvingSingleTargetSpell(at_position, DropData[1])
#		hand_rect.get_child(DropData[2]).queue_free()
#		if MYrena_mid.get_child_count()>0:
#			MYrena_mid.get_child(0).queue_free()
#		await get_tree().create_timer(Base.FAKE_DELTA).timeout
#		hand_rect.collide_cards()
#
#	if DropData[0] == 2:
#		MYrena_rect.EquippingItem = 0
#		MYrena_rect.equipping_the_item(at_position, DropData[1])
#
#		hand_rect.get_child(DropData[2]).queue_free()
#		if MYrena_mid.get_child_count()>0:
#			MYrena_mid.get_child(0).queue_free()
#		await get_tree().create_timer(Base.FAKE_DELTA).timeout
#		hand_rect.collide_cards()








