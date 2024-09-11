extends ColorRect

@onready var Graveyard = $"../../../../../../UI_layer/Graveyard_showcase"
@onready var spawner = $"../../../../../../UI_layer/Spawner/SpawnRect"
@onready var opponent_spawner = $"../../../../../../UI_layer/Spawner/Opponent_spawn_rect_fake"
@onready var scrollh = $"../../../../../../UI_layer/SCROLLH"
@onready var BUTTON = $"../../../../../../UI_layer/THE_BUTTON"
@onready var D12 = $"../../../../../../D12"

@onready var lane = $"../../../../.."
@onready var card_layer = $"../../../../"
@onready var tower_layer = $"../../../../../Tower_layer"
@onready var scroller = $"../../.."
@onready var MYrena_mid = $"../ArenaMid"

# ::::::::::::::::::
@export var CARD: PackedScene
@export var SHADOW: PackedScene
@export var EFFECT: PackedScene
@export var IEFFECT: PackedScene
@export var VOID: PackedScene
@export var STARTSET = (Base.CARD_WIDTH/2.0)
@export var OFFSET = 16
var distance_to_arena = 150
#the arena node isn't glued to the left side of the screen
var Card_and_offset = Base.CARD_WIDTH + OFFSET

#so that these are only calced once
var OWN_Y = self.position.y
var OWN_HEIGHT = self.size.y
var SHADOW_HEIGHT = OWN_Y + OWN_HEIGHT

#vars for placing units:
var Carrying = 0
var Measuring = 0
#vars for aiming spells:
var TargetingSpell = 0
#var Aiming = 0
#vars for equipping items
var EquippingItem = 0
#var Iteming = 0


var OPrena_rect
var OPrena_roof
var MY_identity
#to decide which side I'm on
var OP_identity
#cuz children targeting is by 0 or 1 if we have two towers
var OPTower
var MYTower

var TYPE = 3000
#since this can be targeted, it also has to be able to TYPEChecked
#reason of implementation : unit targeted in covering might be this lane
	#when using blink_axe

var BOFFSET = 250
# if this is abarena, I have to put units lower from top
var AOFFSET = 100

var collide_time = 0.25
# animation time of collide_units()

var my_lane = 0
#calced from 'lane' during ready()

var Are_creeps_being_played_on = false
var Are_heroes_being_played_on = false
#used for control of hover over unit effects when targeting spells and items
#function playing_on()

var has_position_aura_array = []


func _ready():
	if (self.get_parent().get_parent().name) == "Arena":
		MY_identity = "A"
		OP_identity = 1
		OPTower = $"../../../../../Tower_layer/TowerB"
		MYTower = $"../../../../../Tower_layer/TowerA"
	elif (self.get_parent().get_parent().name) == "Abarena":
		MY_identity = "B"
		OP_identity = 0
		OPTower = $"../../../../../Tower_layer/TowerA"
		MYTower = $"../../../../../Tower_layer/TowerB"
	else: push_error("Arena has an identity crisis :(")
	
	OPrena_rect = self.get_parent().get_parent().get_parent().get_parent().get_child(OP_identity).get_child(0).get_child(0).get_child(2)
	OPrena_roof = self.get_parent().get_parent().get_parent().get_parent().get_child(OP_identity).get_child(0).get_child(0).get_child(0)
#	print(self.get_parent().get_parent().name)

	match lane.name:
		"First_lane":
			my_lane = 1
			tower_layer.my_lane = 1
		"Mid_lane":
			my_lane = 2
			tower_layer.my_lane = 2
		"Last_lane":
			my_lane = 3
			tower_layer.my_lane = 3
		_:
			push_error("ArenaRect appeared on an unkown lane")

var Slot_calc_top = 0 - STARTSET # dont scale ----> - distance_to_arena
var	Slot_calc_bot =	Card_and_offset
	
func Adding_Units(_at_position, ID, has_ability):
	Carrying = 0
	var replacing_replacer = 0
	if self.get_child_count()-1 >= Shadow_index:
		if get_child(Shadow_index).Replaced_a_void == 1:
			#replaced_a_void is set to 1 when choosing on which void
				#the preview void is set 
				#aka empty_slots > 0
			replacing_replacer = 1
		RIP_BOZO(get_child(Shadow_index))
	else:
		push_error("NO SHADOW detected>>>>>>>>>>>>>>")
		

	if replacing_replacer == 0:
		OPrena_rect.insert_void(Shadow_index, 1, 1)	
		
		
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	var population = get_child_count()
	var another = CARD.instantiate()
	var DB_slot = CreepsDB.CREEPS_DB[ID]
	another.VOIDING = 0
#	another.Unit_Name = Base.UNITS_DB[ID][Base.NAMEPOSITION]
	another.Unit_Pfp = Base.CREEP_TEXTURES[ID]
	
	another.Unit_Name = DB_slot[CreepsDB.NAMEPOSITION]
	another.Unit_Attack = DB_slot[CreepsDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[CreepsDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[CreepsDB.ARMORPOSITION]
	
	if has_ability == true:
		another.Unit_Ability_texture = Base.CREEP_ABILITY_TEXTURES[ID]
		another.Unit_Ability_cooldown = AbilitiesDB.CREEP_ABILITIES_DB[ID][AbilitiesDB.COOLDOWNPOSITION]
		another.has_ability = true
	
	another.HERO = 0
	another.Identification = ID
	if MY_identity == "B": 
		another.position.y = BOFFSET
	else: another.position.y = AOFFSET
		
	another.my_lane = my_lane
	#to track which lane a unit is in

	
	if Shadow_index > population:
		another.position.x= STARTSET + population * (Card_and_offset)
		add_child(another)
	else:
		another.position.x= STARTSET + Shadow_index * (Card_and_offset)
		add_child(another)
		for i in (population-Shadow_index):
			move_child(get_child(population-(i+1)),population-i)
		collide_units()
	await get_tree().create_timer(Base.FAKE_OMEGA).timeout 
	another.curve_rng()
	#game works almost fine without this
		#as in DTBT is still calced right (Excluding the sommelier bug) but isnt shown
	#Duelyst bug says otherwise
	UNITS_MOVED_YO()
	#signal yo
	
	
	
func Cheating_Units(ID, has_ability):
	var population = get_child_count()
	var another = CARD.instantiate()
	
	another.VOIDING = 0
#	another.Unit_Name = Base.UNITS_DB[ID][Base.NAMEPOSITION]
	another.Unit_Pfp = Base.CREEP_TEXTURES[ID]
	
	var DB_slot = CreepsDB.CREEPS_DB[ID]
	another.Unit_Name = DB_slot[CreepsDB.NAMEPOSITION]
	another.Unit_Attack = DB_slot[CreepsDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[CreepsDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[CreepsDB.ARMORPOSITION]
	
	if has_ability == true:
		another.Unit_Ability_texture = Base.ABILITY_TEXTURES[ID]
		another.Unit_Ability_cooldown = AbilitiesDB.CREEP_ABILITIES_DB[ID][AbilitiesDB.COOLDOWNPOSITION]
		another.has_ability = true
	
	another.HERO = 0
	another.position.x= STARTSET + population * (Card_and_offset)
	
	if MY_identity == "B": 
		another.position.y = BOFFSET
	else: another.position.y = AOFFSET
		
	another.my_lane = my_lane
	#to track which lane a unit is in
	another.Identification = ID
		
	add_child(another)
	

func spawn_unit(ID):
	var spawning_slot = await new_random_slot()
	
#	var population = get_child_count()
	var another = CARD.instantiate()
	
	another.VOIDING = 0
#	another.Unit_Name = Base.UNITS_DB[ID][Base.NAMEPOSITION]
	another.Unit_Pfp = Base.CREEP_TEXTURES[ID]
	
	another.Unit_Attack = CreepsDB.CREEPS_DB[ID][CreepsDB.ATTACKPOSITION]
	another.Unit_Health = CreepsDB.CREEPS_DB[ID][CreepsDB.HEALTHPOSITION]
	another.Unit_Armor = CreepsDB.CREEPS_DB[ID][CreepsDB.ARMORPOSITION]
	
	if CreepsDB.CREEPS_DB[ID][CreepsDB.ABILITYPOSITION] == true:
		another.Unit_Ability_texture = Base.CREEP_ABILITY_TEXTURES[ID]
		another.Unit_Ability_cooldown = AbilitiesDB.CREEP_ABILITIES_DB[ID][AbilitiesDB.COOLDOWNPOSITION]
		another.has_ability = true
	
	another.HERO = 0
	
	another.position.x= STARTSET + spawning_slot * (Card_and_offset)
	if MY_identity == "B": 
		another.position.y = BOFFSET
	else: another.position.y = AOFFSET
		
	another.my_lane = my_lane
	#to track which lane a unit is in
	another.Identification = ID
		
	
	add_child(another)
	move_child(another, spawning_slot)
	collide_units()
	UNITS_MOVED_YO()
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
	another.curve_rng()
	

			
func Remove_Unit(which):	
	if get_child_count() > which:
		RIP_BOZO(get_child(which)) 
		#Dunno how else to wait 1 frame......................
		#Because queue_free takes place at the end of frame
#		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		#RIP_BOZO should make it so that I don't need to wait a frame now
		collide_units()
		
	else: push_error("attempted to remove unit over population")

#Yo you can call functions that are defined later on in gdscript, poggers
func collide_units():

	var population = get_child_count()
	if population > 0:
		var tween = create_tween().set_parallel(true)

		for i in population:
			tween.tween_property(get_child(i),
			 "position:x", STARTSET + (i * (Card_and_offset)),
			collide_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		
#		if curve == true:
#			for i in population:
#				var target = get_child(i)
#				if target.TYPE == 0:
#					target.curve_rng()

		
func fake_collide_units(index):
	#used to collide OPRena units when we are placing a unit
	#to make empty space across where we placin
	
	var population = get_child_count()
	
	if population > 0:
		var tween = get_tree().create_tween().set_parallel(true)	
		for i in population:
			if i < index:
				tween.tween_property(get_child(i),
			 "position:x", STARTSET + (i * (Card_and_offset)),
			0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
			else:
				tween.tween_property(get_child(i),
			 "position:x", STARTSET + ((i+1) * (Card_and_offset)),
			0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
#func place_me_pls(node, index):
#	node.position.x = STARTSET + index * Card_and_offset
#	print("Placing " +str(node) +str("at index " +str(index)))
#
func place_me_at(node, index):
	move_child(node,index)
	node.position.x = STARTSET + index * Card_and_offset
	

	

func _on_arena_roof_mouse_entered():

	if Carrying == 1:
#		print("we do be carrying")
		Measuring = 1
		Shadow_preview()

		
func _on_arena_roof_mouse_exited():
	var replacing_replacer = 0
	Measuring = 0

	
#	for i in MYrena_mid.get_child_count():
#		MYrena_mid.get_child(i).queue_free()

	if Carrying == 1:
		if self.get_child_count() >= New_Slot+1:
			if get_child(New_Slot).TYPE == 8:
				if get_child(New_Slot).Replaced_a_void == 1:
					replacing_replacer = 1
				Remove_Unit(New_Slot)
				OPrena_rect.collide_units()

				if replacing_replacer == 1:
					insert_void(New_Slot, 1,1)
			
			else:
				var population = get_child_count()
				for i in population:
					if get_child(i).TYPE == 8:
						Remove_Unit((get_child(i).get_index()))
						#this basically doesnt happen anymore, but just for sure
						print("KICKED ASS")
		else: push_error("Almost crashed by UFM mexit lol")


func round_to_closest_empty(num, allowed_numbers):
#	var allowed_numbers = [2, 4, 5]
	var closest = allowed_numbers[0]
	var smallest_diff = abs(closest - num)
	
	for i in range(1, allowed_numbers.size()):
		var diff = abs(allowed_numbers[i] - (num))
		if diff < smallest_diff:
			smallest_diff = diff
			closest = allowed_numbers[i]
	
	return closest

var Shadow_index = 0
var empty_slots = []
var New_Slot = 0
func Shadow_preview():
	New_Slot = new_slot_for_shadow_preview()
	
	var population = get_child_count()
	var another = SHADOW.instantiate()
	if MY_identity == "B": 
			another.position.y = BOFFSET
	else: another.position.y = AOFFSET
	if New_Slot >= population:
		another.position.x= STARTSET + population * (Card_and_offset)
		
		add_child(another)
		Shadow_index = another.get_index()
#		print("NS above population")
#		card_layer.slot_care(another)
	else:
		#voidstuff
		var Rtarget = self.get_child(New_Slot)
		if Rtarget.TYPE == 7:
			if Rtarget.SETT == 1:
				another.Replaced_a_void = 1
			RIP_BOZO(Rtarget)
#		print(New_Slot)
		
		add_child(another)
		if New_Slot < 0:
			New_Slot = 0
#			print("NS bellow zero")
			#PREVENTS Startset error (moving last child to i0)
#			print(New_Slot)

#		for i in (population-New_Slot):
		move_child(another,New_Slot)
		another.position.x= STARTSET + New_Slot*Card_and_offset
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		# KEEEEEEEEEEEEEEEEEEP IT HERE 
		# after queuing you have to move children ASAP
		
		if another.Replaced_a_void == 0:
			OPrena_rect.fake_collide_units(New_Slot)
		collide_units()
		Shadow_index = another.get_index()
	Shadow_follow()
	
func Shadow_follow():
	while Carrying == 1 and Measuring == 1:
		New_Slot = new_slot_for_shadow_follow()
		
		var population = get_child_count()
		var NSvsSI = abs(New_Slot-Shadow_index)
		if New_Slot > population -1:
#			print("NS above population")
			New_Slot = population-1
			if NSvsSI > 0.05:
				if Carrying != 1 or Measuring != 1:
					break
				if Shadow_index <= population-1 and New_Slot <= population-1:
					#necessary if statement because of frame 1 shenenigans
					move_child(get_child(Shadow_index), New_Slot)
#				if Shadow_index < OPrena_rect.get_child_count():
#					if OPrena_rect.get_child(Shadow_index).TYPE == 7:
#						OPrena_rect.move_child(OPrena_rect.get_child(Shadow_index), New_Slot)
				
				collide_units()
				OPrena_rect.collide_units()
				
				Shadow_index = New_Slot
		elif NSvsSI > 0.05:
			if New_Slot < 0:
				New_Slot = 0
#			print("SI: " +str(Shadow_index))
#			print("NS: " +str(New_Slot))
#			move_child(get_child(Shadow_index), New_Slot)
			if self.get_child(New_Slot).TYPE == 7:
				swap_children(Shadow_index, New_Slot)	
			else: move_child(get_child(Shadow_index), New_Slot)	
			
			if len(empty_slots) == 0:
				collide_units()
			if self.get_child(New_Slot).Replaced_a_void == 0:
				OPrena_rect.fake_collide_units(New_Slot)
			Shadow_index = New_Slot		#pass
#			print("population is: " +str(population))
#this wasnt it
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
#		await get_tree().create_timer(1).timeout

func new_slot_for_shadow_preview():
	empty_slots = []
	for i in self.get_child_count():
		if self.get_child(i).SITT == 1:
			empty_slots.append(i)
#	print("We do be shadowing")
	var Scroll_value = scroller.get_h_scroll_bar().get_value()
	var Mouse_X = get_global_mouse_position().x - lane.position.x
	
	New_Slot = round(((((1/scroller.scale.x) * (Slot_calc_top + Mouse_X)) + Scroll_value - distance_to_arena)  / (Slot_calc_bot) ))
	#REWORK THIS FROM PAPER IG
	if len(empty_slots) != 0:
		New_Slot = round_to_closest_empty(New_Slot, empty_slots)
	return New_Slot

func new_slot_for_shadow_follow():
	var Scroll_value = scroller.get_h_scroll_bar().get_value()
	var Mouse_X = get_global_mouse_position().x - lane.position.x
	New_Slot = ((((1/scroller.scale.x) * (Slot_calc_top + Mouse_X)) + Scroll_value - distance_to_arena)  / (Slot_calc_bot) )
	empty_slots = []
	for i in self.get_child_count():
		if self.get_child(i).SITT == 1:
			if self.get_child(i).TYPE == 7 or self.get_child(i).Replaced_a_void == 1:
				empty_slots.append(i)
	if len(empty_slots) != 0:
		New_Slot = round_to_closest_empty(New_Slot, empty_slots)
	#round AFTER empty_slots check >>>>>>>>>
	else:
		New_Slot = round(New_Slot)
	return New_Slot
	
func new_random_slot():
	var Random_slot = 0
	empty_slots = []
	for i in self.get_child_count():
		if self.get_child(i).SITT == 1:
			empty_slots.append(i)

	if len(empty_slots) != 0:
		
		randomize()  # Initialize the random number generator
		var random_index = randi() % empty_slots.size()
		Random_slot = empty_slots[random_index]
		var replacing_void = get_child(empty_slots[random_index])
#			var new_x = replacing_void.position.x
		RIP_BOZO(replacing_void)
#		await get_tree().create_timer(Base.FAKE_DELTA).timeout
	else:
		var random_index = randf()
		if random_index <  0.5:
			Random_slot = self.get_child_count()
		OPrena_rect.insert_void(Random_slot, 1, 1)
		
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	return Random_slot
	

func insert_void(index, sett_status = 1, sitt_status = 1):
#	if index <= self.get_child_count():
		#cuz it can spawn excess voids during combat
		#nah this would cause the opposite problem
	var another = VOID.instantiate()
	if MY_identity == "B": 
			another.position.y = BOFFSET
	else: another.position.y = AOFFSET
	if sett_status == 1:
		another.SETT = 1
	if sitt_status == 1:
		another.SITT = 1
		
	add_child(another)
	place_me_at(another, index)
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	#for combat phase to work KEEEEEEEEEEP
	
	collide_units()

func replace_me_by_void(node, index, heroism, sett_status, sitt_status):
	var another = VOID.instantiate()
	if MY_identity == "B": 
			another.position.y = BOFFSET
	else: another.position.y = AOFFSET
	if sett_status == 1:
		another.SETT = 1
	if sitt_status == 1:
		another.SITT = 1
	add_child(another)
	if heroism == 0:
#		node.reparent(card_layer)	
		RIP_BOZO(node)		
	elif heroism == 1:
		node.reparent(Graveyard)
	move_child(another, index)
	collide_units()
	if heroism == 1:
		Graveyard.Add_grave(node, self)
		
func maybe_clean_two_voids(index):
		var A1 = self.get_child(index)
		var B1 = await get_opposer(index)
		if A1 != null and B1 != null:
			if A1.TYPE == 7 and B1.TYPE == 7:	
				RIP_BOZO(A1)
				RIP_BOZO(B1)
	#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
				card_layer.Double_collide()
				UNITS_MOVED_YO()
				#send signal that units moved
		else:
			push_error("MAYBE_CLEAN_TWO_VOIDS encountered null target")
				
func get_opposer(Index):
	#I cant add an incorect argument check here because it wouldnt get to while loop
	#which would ruin the primary purpose of this function
	var opposer = OPrena_rect.get_child(Index)
#	var mb_opposer
	while opposer == null or (opposer.TYPE == 0 and opposer.alive == 0):
		await get_tree().create_timer(Base.FAKE_DELTA).timeout 
		opposer = OPrena_rect.get_child(Index)

	return opposer		
	
func swap_children(index1, index2):
	var child1 = get_child(index1)
	var child2 = get_child(index2)

	place_me_at(child1, index2)
	place_me_at(child2, index1)
#	node.move_child(child2, index1)
#	node.place_me_pls(child2,index1)



#func delayed_setting(type, number):
#	#this might prevent the cursor moving to right left
#	#after releasing card preview bug 
#	#by making it invisible because 
#	#CardInHand Preview doesnt spawn until EquippingItem is set to 0
#	await get_tree().create_timer(2).timeout 
#	match type:
#		0:#UNIT
#			Carrying = 0
#		1:#SPELL
#			TargetingSpell = 0
#		2:#ITEM
#			EquippingItem = 0
	

func playing_on(Is_played_on):
	if Is_played_on == "Unit":
		Are_creeps_being_played_on = true
		Are_heroes_being_played_on = true
#		print("units are being played on")
		
	elif Is_played_on == "Hero":
		Are_heroes_being_played_on = true
		
	elif Is_played_on == "Creep":
		Are_creeps_being_played_on = true
		
func not_playing_on_anymore():
	Are_creeps_being_played_on = false
	Are_heroes_being_played_on = false


func a_spell_is_being_dragged(Is_played_on):
	TargetingSpell = 1
	playing_on(Is_played_on)

func a_spell_is_no_longer_being_dragged():
	TargetingSpell = 0
	not_playing_on_anymore()
	
func an_item_is_being_dragged():
	EquippingItem = 1
	playing_on("Hero")

func an_item_is_no_longer_being_dragged():
	EquippingItem = 0
	not_playing_on_anymore()


func create_hero(ID):
	#Used at the start of game to create the hero scenes and prepare them
	var another = CARD.instantiate()
	var DB_slot = HeroesDB.HEROES_DB[ID]
	
	another.Unit_Pfp = Base.HERO_TEXTURES[ID]
	another.Unit_Icon = Base.ICON_TEXTURES[ID] 		#TESTUS HEREEEEEEEEE
	
	another.Unit_Ability_texture = Base.ABILITY_TEXTURES[ID]
	another.Unit_Ability_cooldown = AbilitiesDB.HERO_ABILITIES_DB[ID][AbilitiesDB.COOLDOWNPOSITION]
	#all heroes have an ability
	another.Unit_Name = str(DB_slot[HeroesDB.NAMEPOSITION])
	another.Unit_Attack = DB_slot[HeroesDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[HeroesDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[HeroesDB.ARMORPOSITION]
	another.Lvlup_xp = DB_slot[HeroesDB.XPPOSITION]

	another.HERO = 1
	another.Identification = ID
	another.VOIDING = 0
	#idk
	another.has_ability = true
	
	OPrena_rect.insert_void(0, 1, 1)
	add_child(another)
	if MY_identity == "A":
		Base.Player_heroes.append(another)
	else:
		Base.Opponent_heroes.append(another)
#		print("AbarenaRect appended Base.Opponent_heroes")


#var fake_number = -1
func transfer_hero_to_spawner(target):
	#used at the beginning of the game to move the heroes that were created here
	#to spawner from which they can be sent elsewhere
	target.appear_dead()
	remove_child(target)
	if MY_identity == "A":
		spawner.add_child(target)
	else: 
		opponent_spawner.add_child(target)
	
	
	insert_void(0,1,1)

	
	#otherwise they would've remember they are already attacking the tower
	
#	fake_number += 1
#	OPrena_rect.get_child(fake_number).queue_free()
	#this removes the temporary void 
	#which is necc for the full ready function of unit
	
	
func respawn_here(target):
	
	target.straight_target = null
	target.side_target = null
	target.damage_used_up_1 = 0
	target.damage_used_up_2 = 0
	#they might rember what they were targeting previously
	##################################################################
	#MUST BE HERE TO START THE GAME CUZ HEROES ARE MADE IN L1
	##################################################################
	target.scale = Vector2(1,1)
	
	var landing_slot = await new_random_slot()
	target.reparent(self)
	move_child(target, landing_slot)
	target.respawn(1)
		#includes new_lane and repositioning based around BOFFSET
	collide_units()
	UNITS_MOVED_YO()
	#sends signal yo
	
func land_here(target):
	#same as respawn_here but for when a unit enters this lane from elsewhere
	#D12 is used
	
	var landing_slot = await new_random_slot()
	target.reparent(self)
	move_child(target, landing_slot)
	target.land()
	printerr("target landed")
	
	collide_units()
	UNITS_MOVED_YO()
	#sends signal yo

func spawn_lane_creep():
	var spawning_slot = await new_random_slot()		
	
	var another = CARD.instantiate()
	var ID = 0
	var DB_slot = CreepsDB.SPECIAL_DB[ID]
	another.VOIDING = 0
	
	
	another.Unit_Attack = DB_slot[CreepsDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[CreepsDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[CreepsDB.ARMORPOSITION]
	
	another.HERO = 0
	another.Identification = ID
	if MY_identity == "A":
		another.Unit_Pfp = Base.SPECIAL_TEXTURES[ID]
		another.position.y = AOFFSET
	elif MY_identity == "B": 
		another.position.y = BOFFSET
		another.Unit_Pfp = Base.SPECIAL_TEXTURES[ID+1]
		
	another.my_lane = my_lane
	#to track which lane a unit is in
	
	add_child(another)
	move_child(another, spawning_slot)
	collide_units()
#	another.respawn()
	
func reset_curving():
	#BRATTY CURVING, NEEDS TO BE CORRECTED
	var population = get_child_count()
	for i in population:
		var target = get_child(i)
		if target.TYPE == 0:
			target.reset_curve()
			
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 

			
	for i in population:
		var target = get_child(i)
		if target.TYPE == 0:
			target.curve_rng()		
	
	
func is_there_a_hero_check():
	if Base.PLAYTEST == 1:
		var population = get_child_count()
		var target
		for i in population:
			target = get_child(i)
			if target.TYPE == 0 and target.HERO == 1:
				return true
		return false
	print("there is always a caster")
	return true
	
func is_there_a_unit_check():
	var population = get_child_count()
	var target
	for i in population:
		target = get_child(i)
		if target.TYPE == 0:
			return true
	return false

func UNITS_MOVED_YO():
	if Base.current_lane != 4:
		tower_layer.unit_order_changed_signal(my_lane)
	#because that's deploying lane, I need everything to land 
	#and then this sgnal is called via THE BUTTON

func refresh_annulled_units():
	var population = get_child_count()
	var target
	for i in population:
		target = get_child(i)
		if target.TYPE == 0 and target.my_damage_was_annuled == true:
			target.refresh_me_from_being_annulled()
		
		
		
func RIP_BOZO(target):
	#takes a void as target, reparents them to D12
	target.reparent(D12)		
	target.queue_free()
		
		
		
		
		
		
		
		
