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

var abarena: Node
#found during _ready
var arena_meine: Node

# ::::::::::::::::::
@export var CARD: PackedScene
@export var SHADOW: PackedScene
@export var EFFECT: PackedScene
@export var IEFFECT: PackedScene
@export var VOID: PackedScene
@export var STARTSET = (Base.CARD_WIDTH/2.0)
@export var OFFSET = 30
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

var colliding = 0
#whether collide_units() is running

var OPrena_rect
var OPrena_roof
var MY_identity
#to decide which side I'm on
#var OP_identity
#cuz children targeting is by 0 or 1 if we have two towers
	#yeaah nah
var OPTower
var MYTower

var TYPE:String = "lane"
#since this can be targeted, it also has to be able to TYPEChecked
#reason of implementation : unit targeted in covering might be this lane
	#when using blink_axe

var BOFFSET = 250
# if this is abarena, I have to put units lower from top
var AOFFSET:int #has to be calced in ready() due to parent property access 
	
var collide_time = 0.25
# animation time of collide_units()

var my_lane:int = 0
#calced from 'lane' during ready()

var Are_creeps_being_played_on = false
var Are_heroes_being_played_on = false
#used for control of hover over unit effects when targeting spells and items
#function playing_on()

var has_position_aura_array = []


func _ready():
	AOFFSET = 100 + (275 / scroller.scale.y ) 
		#addition cuz SCROLLA has been moved higher, to allow for allowing to swap
		#child order when we need to target only our lane (SCROLLA moves to front)

	if (self.get_parent().get_parent().name) == "Arena":
		MY_identity = "A"
		#OP_identity = 1
		OPTower = $"../../../../../Tower_layer/TowerB"
		MYTower = $"../../../../../Tower_layer/TowerA"
		abarena = $"../../../../SCROLLB/Abarena/SIZECHECK/ArenaRect"
		OPrena_rect = $"../../../../SCROLLB/Abarena/SIZECHECK/ArenaRect"
		OPrena_roof = $"../../../../SCROLLB/Abarena/SIZECHECK/ArenaRoof"
				
	elif (self.get_parent().get_parent().name) == "Abarena":
		MY_identity = "B"
		#OP_identity = 0
		OPTower = $"../../../../../Tower_layer/TowerA"
		MYTower = $"../../../../../Tower_layer/TowerB"
		arena_meine = $"../../../../SCROLLA/Arena/SIZECHECK/ArenaRect"
		OPrena_rect = $"../../../../SCROLLA/Arena/SIZECHECK/ArenaRect"
		OPrena_roof = $"../../../../SCROLLA/Arena/SIZECHECK/ArenaRoof"
		
	else: push_error("Arena has an identity crisis :(")
	
	#OPrena_rect = self.get_parent().get_parent().get_parent().get_parent().get_child(OP_identity).get_child(0).get_child(0).get_child(2)
	#OPrena_roof = self.get_parent().get_parent().get_parent().get_parent().get_child(OP_identity).get_child(0).get_child(0).get_child(0)
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
			

var Slot_calc_top = 0 - STARTSET - OFFSET # dont scale ----> - distance_to_arena
var	Slot_calc_bot =	Card_and_offset
	
@rpc("any_peer", "call_remote", "reliable")
func Adding_Units(_at_position, ID):
	#THIS function is for when units are dropped from card 
	
	#howto shadowindex lemao
	
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
	another.Card_pfp = Base.CREEP_TEXTURES[ID]
	
	another.Unit_Name = DB_slot[CreepsDB.NAMEPOSITION]
	another.Unit_Attack = DB_slot[CreepsDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[CreepsDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[CreepsDB.ARMORPOSITION]
	
	
	
	another.HERO = false
	another.Identification = ID
	
	another = handle_has_ability_for_creeps(another)
	
	if MY_identity == "B": 
		another.position.y = BOFFSET
	else: another.position.y = AOFFSET
		
	another.my_lane = my_lane
	#to track which lane a unit is in

	
	if Shadow_index > population:
		another.position.x= STARTSET + population * (Card_and_offset)
		add_child(another)
	else:
		another.position.x= OFFSET + STARTSET + Shadow_index * (Card_and_offset)
		#same as above, mb historical diff
		add_child(another)
#		for i in (population-Shadow_index):
#			move_child(get_child(population-(i+1)),population-i)
				#ancient
		move_child(another, Shadow_index)
		collide_units()
		
	another.sfx_base.play()
	#sound of landing
	
	if Lobby.MULTIPLAYER == true:
		rpc_id(Lobby.opponent_peer_id, "spawn_unit", ID, 1, Shadow_index,  false)
		#another.second_ready() #_without_curve_rng
		#push_error("mult true and lobbyhost false")
	#else:
	await get_tree().create_timer(Base.FAKE_OMEGA).timeout 
	another.second_ready() #on adding no curving #_without_curve_rng
		#these two lines also work for SP
			

	UNITS_MOVED_YO()
	#signal yo
	
	
	
	
	
func Cheating_Units(ID, has_ability):
	var population = get_child_count()
	var another = CARD.instantiate()
	
	another.VOIDING = 0
#	another.Unit_Name = Base.UNITS_DB[ID][Base.NAMEPOSITION]
	another.Card_pfp = Base.CREEP_TEXTURES[ID]
	
	var DB_slot = CreepsDB.CREEPS_DB[ID]
	another.Unit_Name = DB_slot[CreepsDB.NAMEPOSITION]
	another.Unit_Attack = DB_slot[CreepsDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[CreepsDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[CreepsDB.ARMORPOSITION]
	
	if has_ability == true:
		another.Unit_Ability_texture = Base.ABILITY_TEXTURES[ID]
		another.Unit_Ability_cooldown = AbilitiesDB.CREEP_ABILITIES_DB[ID][AbilitiesDB.COOLDOWNPOSITION]
		another.has_ability = true
	
	another.HERO = false
	another.position.x= STARTSET + population * (Card_and_offset)
	
	if MY_identity == "B": 
		another.position.y = BOFFSET
	else: another.position.y = AOFFSET
		
	another.my_lane = my_lane
	#to track which lane a unit is in
	another.Identification = ID
		
	add_child(another)
	
var spawning_units = 0
#used to keep track of how many units are still being summoned
	#mass_second_ready only triggers when spawning_units == 0
	#so its a for of waiting condition
@rpc("any_peer", "call_remote", "reliable") 
func spawn_unit(ID, amount, rpced_slots = null, forced_here = false, readied = true):
	#THIS function is for when units are spawned from effect
	#spawning_units += 1
	var spawning_slots = []
	var slot_to_be_added = 0
	#becomes array [int, bool] when keeping_voids
				#[slot index, whether it added a new void]
	var keep_voids = false
	if amount > 1:
		keep_voids = true
	#we keep voids so that we can replace units in their place
			#and simplifiy calculations of slots when spawning multiple units
	var original_spawning_slots = []
	#these are spawning slots in order we calc them before rpcing them,
		#unmodified by 0th index void and less affected by boost
		#receiver uses the same func to create spawning_slots
		
	if multiplayer.get_remote_sender_id()== 0 or forced_here == true:
		var boost = 0
		#for every unit spawned at the highest index, all other highest index units
			#must have their index increased by 1
		for i in amount:
			if rpced_slots == null:	
				slot_to_be_added = await new_random_slot(null, keep_voids)
			else:
				var target_slot
				if rpced_slots is int or rpced_slots is float: #no idea how it becomes float
					target_slot = rpced_slots
					#used when one player plays unit from hand (Adding_units())
						#and rpcs the unit to opponent, which is then spawned
						#mb also sp?
				elif rpced_slots is Array and (rpced_slots[i] is int or rpced_slots[i] is float):
					target_slot = rpced_slots[i]
					#used when a single unit is being spawned 
					#three different ways to do one thing agane huh
						#each of them is optimal for their use ig, else we'd need to fill with nulls
				else:
					target_slot = rpced_slots[i][0]
				slot_to_be_added = await new_random_slot(target_slot, keep_voids)
			if amount > 1 and slot_to_be_added[1] == true: 
				#push_error("comparison of slot_to_be_added and childcount: " +str(slot_to_be_added) + " / " +str(get_child_count()))			
				if slot_to_be_added[0] == 0:
					#when a new void at id 0 has been added
					for j in spawning_slots.size():
						spawning_slots[j][0] += 1
						#push_error("increasing spawning_slots[" +str(j) + "][0] by 1")
					#this calc is simplified when keeping voids
				slot_to_be_added[0] += boost
				if slot_to_be_added[0] == get_child_count():
					#when a new void at max id has been added
					#has to be after the old boost has been applied
					boost += 1
						
			spawning_slots.append(slot_to_be_added)
			 	
			if rpced_slots == null and Lobby.MULTIPLAYER == true:
				#we must prepare original_spawning_slots to rpc them
				var decreased_boost = boost -1
				if decreased_boost < 0:
					decreased_boost = 0
				if amount > 1:
					original_spawning_slots.append([slot_to_be_added[0] - decreased_boost, slot_to_be_added[1]])
				else:
					original_spawning_slots.append(slot_to_be_added)
	
	elif forced_here == false:
			#spawning_slots = rpced_slots
			##new_radnom_slot GENERATES VOIDS !!! 
			#
			if abarena:
				#if abarena isn't null <=> I'm not abarena
				push_error("telling abarena to spawn creeps at " +str(rpced_slots))
				await abarena.spawn_unit(ID, amount, rpced_slots, true, false)
				#spawning_units -= 1
				return
			elif arena_meine:
				push_error("telling arena_meine to spawn creeps at " +str(rpced_slots))
				await arena_meine.spawn_unit(ID, amount, rpced_slots, true, false)
				#spawning_units -= 1
				return
		#elif  forced_here == true:
			#for i in amount:
				#slot_to_be_added = await new_random_slot(rpced_slots[i], keep_voids)
				#spawning_slots.append(slot_to_be_added) 			#voids need to be created after arena or abarena is decided
	#if Lobby.MULTIPLAYER == true and Lobby.host == true and rpced_slot == null:
	##multiplayer check isn't necessary here, but I want to signify all parts
		##of the code that are for MP purpose only
		#push_error("Host calling to spawn_unit " +str(ID))
		#rpc_id(Lobby.opponent_peer_id, "spawn_unit", ID, spawning_slot, forced_here)
		#so that the unit is first created at joiner, since he can't mirrorcurve
		
#	var population = get_child_count()
	#push_error("spawning slots prepared: " +str(spawning_slots))
	var anothers = []
	for i in amount:
		var another = CARD.instantiate()
		
		another.VOIDING = 0
	#	another.Unit_Name = Base.UNITS_DB[ID][Base.NAMEPOSITION]
		another.Card_pfp = Base.CREEP_TEXTURES[ID]
		
		another.Unit_Attack = CreepsDB.CREEPS_DB[ID][CreepsDB.ATTACKPOSITION]
		another.Unit_Health = CreepsDB.CREEPS_DB[ID][CreepsDB.HEALTHPOSITION]
		another.Unit_Armor = CreepsDB.CREEPS_DB[ID][CreepsDB.ARMORPOSITION]
		
		another.Identification = ID
		another = handle_has_ability_for_creeps(another)
		
		another.HERO = false
		if amount > 1:
			another.position.x= OFFSET + STARTSET + spawning_slots[i][0] * (Card_and_offset)
		else:
			another.position.x= OFFSET + STARTSET + spawning_slots[i] * (Card_and_offset)
		if MY_identity == "B": 
			another.position.y = BOFFSET
		else: another.position.y = AOFFSET
			
		another.my_lane = my_lane
		#to track which lane a unit is in

		
			
		
		add_child(another)
		if amount == 1:
			move_child(another, spawning_slots[i])
		anothers.append(another)
		another.sfx_base.play()
		#landing sound
	##############
	if amount > 1:
		for i in amount:
			make_child_replace_void(anothers[i], spawning_slots[i][0])
	##############		
	if Lobby.MULTIPLAYER == true and rpced_slots == null: #  and Lobby.host == false 
	##multiplayer check isn't necessary here, but I want to signify all parts
		##of the code that are for MP purpose only
			##wtf it is else it would trigger in SP
		#var clean_spawning_slots = []
		#if amount > 1:
			#for i in amount:
				#clean_spawning_slots.append(spawning_slots[i][0])
			#push_error("clean spawning slots: " + str(clean_spawning_slots))
		#else:
			#clean_spawning_slots = spawning_slots
		push_error("rpcing to spawn units at " + str(original_spawning_slots))
		rpc_id(Lobby.opponent_peer_id, "spawn_unit", ID, amount, original_spawning_slots, forced_here)
		##so that the unit is created also at host, but after mine
		
		#we will only rpc the function via returning clean spawning slots
	##############
	
			
	collide_units()
	UNITS_MOVED_YO()
	
	if readied == true:
		for i in amount:
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
			#if Lobby.MULTIPLAYER == true:
				#another.second_ready()
				#if Lobby.host == true:
					#another.second_ready()
				#else:
					#another.second_ready_without_curve_rng()
			#else: another.second_ready()		
			anothers[i].second_ready()	
	elif  readied == false:
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		mass_second_ready()
		
	await get_tree().create_timer(Base.FAKE_DELTA).timeout	
	return 0

	

			
func Remove_Unit(which):
	var over_void:bool = false
	var target = get_child(which)
	#used only when dragging a unit and exiting the select area (ArenaRoof)	
	if target.Replaced_a_void == 1:
		over_void = true
		
	if get_child_count() > which:
		RIP_BOZO(target) 
		#Dunno how else to wait 1 frame......................
		#Because queue_free takes place at the end of frame
#		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		#RIP_BOZO should make it so that I don't need to wait a frame now
		
		if over_void == false:
			collide_units()  #rip
		
	else: push_error("attempted to remove unit over population")

#Yo you can call functions that are defined later on in gdscript, poggers
func collide_units(include_y_axis:bool = false):
	colliding += 1
	#to keep track whether this is running
	var population = get_child_count()
	if population > 0:
		var tween = create_tween().set_parallel(true)

		for i in population:
			tween.tween_property(get_child(i),
			 "position:x", OFFSET + STARTSET + (i * (Card_and_offset)),
			collide_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			if include_y_axis:
				if abarena:
					tween.tween_property(get_child(i),"position:y",AOFFSET, collide_time)
				else:
					tween.tween_property(get_child(i),"position:y",BOFFSET, collide_time)
		await tween.finished	
#		if curve == true:
#			for i in population:
#				var target = get_child(i)
#				if target.TYPE == "unit:
#					target.curve_rng()
	colliding -= 1
	#to keep track whether this is running
		
func fake_collide_units(index):
	#used to collide OPRena units when we are placing a unit
	#to make empty space across where we placin
	
	var population = get_child_count()
	
	if population > 0:
		var tween = get_tree().create_tween().set_parallel(true)	
		for i in population:
			if i < index:
				tween.tween_property(get_child(i),
			 "position:x", OFFSET + STARTSET + (i * (Card_and_offset)),
			0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
			else:
				tween.tween_property(get_child(i),
			 "position:x", OFFSET + STARTSET + ((i+1) * (Card_and_offset)),
			0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
#func place_me_pls(node, index):
#	node.position.x = STARTSET + index * Card_and_offset
#	print("Placing " +str(node) +str("at index " +str(index)))
#

func handle_has_ability_for_creeps(creep) -> Node:
	#can only be used if it already has assigned Identification
	var ID = creep.Identification
	if CreepsDB.CREEPS_DB[ID][CreepsDB.ABILITYPOSITION] == true:
		creep.Unit_Ability_texture = Base.CREEP_ABILITY_TEXTURES[ID]
		creep.Unit_Ability_cooldown = AbilitiesDB.CREEP_ABILITIES_DB[ID][AbilitiesDB.COOLDOWNPOSITION]
		creep.has_ability = true
	return creep
		
func place_me_at(node, index):
	move_child(node,index)
	node.position.x = OFFSET + STARTSET + index * Card_and_offset
	

	

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
			if get_child(New_Slot).TYPE == "shadow":
				if get_child(New_Slot).Replaced_a_void == 1:
					replacing_replacer = 1
				Remove_Unit(New_Slot)
				OPrena_rect.collide_units()

				if replacing_replacer == 1:
					insert_void(New_Slot, 1,1)
			
			else:
				var population = get_child_count()
				for i in population:
					if get_child(i).TYPE == "shadow":
						Remove_Unit((get_child(i).get_index()))
						#this basically doesnt happen anymore, but just for sure
						push_error("KICKED ASS")
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
		another.position.x= OFFSET + STARTSET + population * (Card_and_offset)
		
		add_child(another)
		Shadow_index = another.get_index()
#		print("NS above population")
#		card_layer.slot_care(another)
	else:
		#voidstuff
		var Rtarget = self.get_child(New_Slot)
		if Rtarget.TYPE == "void":
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
		another.position.x= OFFSET + STARTSET + New_Slot*Card_and_offset
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
		#New_Slot = new_slot_for_shadow_preview()

		
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
#					if OPrena_rect.get_child(Shadow_index).TYPE == "shadow:
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
			if self.get_child(New_Slot).TYPE == "void":
				swap_children(Shadow_index, New_Slot)	
			else: move_child(get_child(Shadow_index), New_Slot)	
			
			if len(empty_slots) == 0:
				collide_units()
			if self.get_child(New_Slot).Replaced_a_void == 0:
				OPrena_rect.fake_collide_units(New_Slot)
			Shadow_index = New_Slot		#pass
#			print("population is: " +str(population))
#this wasnt it
		await get_tree().create_timer(Base.FAKE_GAMMA).timeout
#		await get_tree().create_timer(1).timeout

func new_slot_for_shadow_preview():
	empty_slots = []
	for i in self.get_child_count():
		if self.get_child(i).SITT == 1:
			empty_slots.append(i)
#	print("We do be shadowing")
	var Scroll_value = scroller.get_h_scroll_bar().get_value()
	var Mouse_X = get_global_mouse_position().x - lane.position.x
	
	New_Slot = ((((1/scroller.scale.x) * (Slot_calc_top + Mouse_X)) + Scroll_value - distance_to_arena)  / (Slot_calc_bot) )
	#REWORK THIS FROM PAPER IG
	if len(empty_slots) != 0:
		New_Slot = round_to_closest_empty(New_Slot, empty_slots)
	else:
		New_Slot = round(New_Slot)
	return New_Slot

func new_slot_for_shadow_follow():
	var Scroll_value = scroller.get_h_scroll_bar().get_value()
	var Mouse_X = get_global_mouse_position().x - lane.position.x
	New_Slot = ((((1/scroller.scale.x) * (Slot_calc_top + Mouse_X)) + Scroll_value - distance_to_arena)  / (Slot_calc_bot) )
	empty_slots = []
	for i in self.get_child_count():
		if self.get_child(i).SITT == 1:
			if self.get_child(i).TYPE == "void" or self.get_child(i).Replaced_a_void == 1:
				empty_slots.append(i)
	if len(empty_slots) != 0:
		New_Slot = round_to_closest_empty(New_Slot, empty_slots)
	#round AFTER empty_slots check >>>>>>>>>
	else:
		New_Slot = round(New_Slot)
	return New_Slot
	
func new_random_slot(forced_slot = null, keep_voids = false):
	#forced_slot is used for multiplayer
	var population = get_child_count()
	var Random_slot = 0
	var empty_random_slots = []
	#just to name it diff from the global before killing the global
	for i in population:
		var target = self.get_child(i)
		if target.SITT == 1:
			
			#push_error("appending empty_random_slots by " +str(target.TYPE) + " at " +str(i))
			empty_random_slots.append(i)

	if len(empty_random_slots) != 0:
		if forced_slot == null:
			randomize()  # Initialize the random number generator
			var random_index = randi() % empty_random_slots.size()
			Random_slot = empty_random_slots[random_index]
			var replacing_void = get_child(empty_random_slots[random_index])
	#			var new_x = replacing_void.position.x
			if keep_voids == false:
				RIP_BOZO(replacing_void)
			else:
				replacing_void.SITT = 0
	#		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		elif forced_slot != null:
			if forced_slot >= population:
				forced_slot = population
				push_error("forced slot above population")
				#happens when multispawning
				
			for i in len(empty_random_slots):
				if empty_random_slots[i] == forced_slot:
					Random_slot = empty_random_slots[i]
					var replacing_void = get_child(empty_random_slots[i])
					replacing_void.SITT = 0
					if keep_voids == false:
						RIP_BOZO(replacing_void)

		if keep_voids == true:
			Random_slot = [Random_slot, false]			
	else:
		if forced_slot == null:
			var random_index = randf()
			if random_index <  0.5:
				Random_slot = self.get_child_count()
			OPrena_rect.insert_void(Random_slot, 1, 1)
			if keep_voids == true:
				insert_void(Random_slot, 1, 0)
				Random_slot = [Random_slot, true]
		elif forced_slot == 0:
			OPrena_rect.insert_void(Random_slot, 1, 1)
			if keep_voids == true:
				insert_void(Random_slot, 1, 0)
				Random_slot = [Random_slot, true]
			#random slot is already 0
		elif forced_slot > 0:
			Random_slot = forced_slot #self.get_child_count()
			OPrena_rect.insert_void(Random_slot, 1, 1)
			if keep_voids == true:
				insert_void(Random_slot, 1, 0)
				Random_slot = [Random_slot, false]
			#rightmost slot
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	#push_error("returning new random slot: " + str(Random_slot))
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
	await place_me_at(another, index)
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	#for combat phase to work KEEEEEEEEEEP
	
	collide_units()
	
func insert_two_voids(index, sett_status = 1, sitt_status = 1):
	insert_void(index, sett_status, sitt_status)
	OPrena_rect.insert_void(index, sett_status, sitt_status)

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
	return 0
		
func maybe_clean_two_voids(index):
		var A1 = self.get_child(index)
		var B1 = await get_opposer(index)
		if A1 != null and B1 != null:
			if A1.TYPE == "void" and B1.TYPE == "void":	
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
	#push_error("OPP?")
	var opposer = OPrena_rect.get_child(Index)
#	var mb_opposer
	while opposer == null or (opposer.TYPE == "unit" and opposer.alive == false):
		await get_tree().create_timer(Base.FAKE_DELTA).timeout 
		opposer = OPrena_rect.get_child(Index)
		if OPrena_rect.get_child_count() <= Index:
			break
	
	return opposer		
	
func swap_children(index1, index2):
	var child1 = get_child(index1)
	var child2 = get_child(index2)

	place_me_at(child1, index2)
	place_me_at(child2, index1)
#	node.move_child(child2, index1)
#	node.place_me_pls(child2,index1)

func extract_children_into_array():
	var result_array = []
	for i in get_child_count():
		var target = get_child(i)
		if target.TYPE == "unit":
			result_array.append(target)
		else:
			result_array.append(null)
			
	return result_array

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
	
	another.Card_pfp = Base.HERO_TEXTURES[ID]
	another.Unit_Icon = Base.ICON_TEXTURES[ID] 		#TESTUS HEREEEEEEEEE
	
	another.Unit_Ability_texture = Base.ABILITY_TEXTURES[ID]
	another.Unit_Ability_cooldown = AbilitiesDB.HERO_ABILITIES_DB[ID][AbilitiesDB.COOLDOWNPOSITION]
	#all heroes have an ability
	another.Unit_Name = str(DB_slot[HeroesDB.NAMEPOSITION])
	another.Unit_Attack = DB_slot[HeroesDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[HeroesDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[HeroesDB.ARMORPOSITION]
	another.Lvlup_xp = DB_slot[HeroesDB.XPPOSITION]

	another.HERO = true
	another.Identification = ID
	another.VOIDING = 0
	#idk
	another.has_ability = true
	another.readied = true
	
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
	
	target.force_remove_myself_from_trigger_array()
	await target.appear_dead()
#	push_error("transfering: " +str(target.Unit_Name) + " to spawner")
	remove_child(target)
	if MY_identity == "A":
		spawner.add_child(target)
	else: 
		opponent_spawner.add_child(target)
	
	
	await insert_void(0,1,1)

	
	#otherwise they would've remember they are already attacking the tower
		#???
	
@rpc("any_peer", "call_remote", "reliable")
func respawn_here(target, rpced_slot = null, faction = null):
	#target starts as int of ID and becomes node of Hero
	if faction != null:
		#when rpced to us
#		push_error(faction + " hero is respawning at " +str(rpced_slot))
		if faction == "alpha":
			target = Base.Player_heroes[target]
		elif faction == "beta":
			target = Base.Opponent_heroes[target]
		else: push_error("unknown respawn_here faction value")
		#if this was rpced to us, 'target' contains index where to look for the hero
			#else its the node
	target.straight_target = null

	#target.side_target = null
	#target.damage_used_up_1 = 0
	#target.damage_used_up_2 = 0
	#they might rember what they were targeting previously
	##################################################################
	#MUST BE HERE TO START THE GAME CUZ HEROES ARE MADE IN L1
	##################################################################
	target.scale = Vector2(1,1)
	var landing_slot
	if rpced_slot == null:
		landing_slot = await new_random_slot()
	else:
		landing_slot = await new_random_slot(rpced_slot)
		
	target.reparent(self)
	move_child(target, landing_slot)
	target.respawn(1)
		#includes new_lane and repositioning based around BOFFSET
	collide_units()
	UNITS_MOVED_YO()
	#sends signal yo
	
	if Lobby.MULTIPLAYER == true and rpced_slot == null:
		#if we need to send over information where to land to joiner
		#we must turn hero into ID again
		var opposite_faction = "beta"
		var index = Base.Player_heroes.find(target)
		#returns index of target in the Herodeck
		if index == -1:
			#if we didn't find it
			index = Base.Opponent_heroes.find(target)
			opposite_faction = "alpha"
		if index == -1:
			#if it wasn't found it opponentHeroDeck either
			push_error("Respawn target not found in either of the herodecks")
		else: 
			if abarena:
				abarena.rpc_id(Lobby.opponent_peer_id, "respawn_here", index, landing_slot, opposite_faction)
			elif arena_meine:
				arena_meine.rpc_id(Lobby.opponent_peer_id, "respawn_here", index, landing_slot, opposite_faction)
			else: push_error("abarena nor arena_meine is available")
	#Trying to do this by waves
	#nvm
	#mb dividing the Unit1.gd _ready() into two parts will solve the problem
	
		
func land_here(lander, forced_slot):
	push_error("landhereing")
	#same as respawn_here but for when a unit enters this lane from elsewhere
	#D12 is used
	var landing_slot
	if forced_slot != null:
		landing_slot = await new_random_slot(forced_slot)
	else:
		landing_slot = await new_random_slot()
	lander.reparent(self)
	move_child(lander, landing_slot)
	await lander.land()
	
	
	
	
	collide_units()
	UNITS_MOVED_YO()
	#sends signal yo
	
	return landing_slot

@rpc("any_peer", "call_remote", "reliable")
func spawn_lane_creep(rpced_slot = null, forced_here = false):
	var spawning_slot
	if rpced_slot == null:
		spawning_slot = await new_random_slot()		
	else:
		if forced_here == false:
			spawning_slot = rpced_slot
			#new_radnom_slot GENERATES VOIDS !!! 
			
			if abarena:
				#if abarena isn't null <=> I'm not abarena
				abarena.spawn_lane_creep(rpced_slot, true)
#				push_error("telling abarena to spawn creep at " +str(rpced_slot))
				return
			elif arena_meine:
				arena_meine.spawn_lane_creep(rpced_slot, true)
#				push_error("telling arena_meine to spawn creep at " +str(rpced_slot))
				return
		elif  forced_here == true:
			spawning_slot = await new_random_slot(rpced_slot)
			#voids need to be created after arena or abarena is decided
			
#	push_error("creating creep at:" +str(rpced_slot) +" " +str(abarena) +" " +str(arena_meine))
	var another = CARD.instantiate()
	var ID = 0
	var DB_slot = CreepsDB.SPECIAL_DB[ID]
	another.VOIDING = 0
	
	
	another.Unit_Attack = DB_slot[CreepsDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[CreepsDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[CreepsDB.ARMORPOSITION]
	
	another.HERO = false
	another.Identification = ID
	if MY_identity == "A":
		another.Card_pfp = Base.SPECIAL_TEXTURES[ID]
		another.position.y = AOFFSET
	elif MY_identity == "B": 
		another.position.y = BOFFSET
		another.Card_pfp = Base.SPECIAL_TEXTURES[ID+1]
		
	another.my_lane = my_lane
	#to track which lane a unit is in
	#another.readied = true #ig HERE
	another.readied = true
	
	add_child(another)
	move_child(another, spawning_slot)
	collide_units()
	another.respawn()
	if Lobby.MULTIPLAYER == true and rpced_slot == null:
		#multiplayer check isn't necessary here, but I want to signify all parts
			#of the code that are for MP purpose only
		rpc_id(Lobby.opponent_peer_id, "spawn_lane_creep", spawning_slot)
	#trying to do this by waves
	#nvm
#		push_error("sending joiner order to spawn a lane creep at " +str(spawning_slot))
	#if Lobby.MULTIPLAYER == true and rpced_slot != null:
		#push_error("random creep spawned for joiner")
	UNITS_MOVED_YO()
	
func reset_curving():
	#BRATTY CURVING, NEEDS TO BE CORRECTED
	var population = get_child_count()
	for i in population:
		var target = get_child(i)
		if target.TYPE == "unit":
			target.reset_curve()
			
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 

			
	for i in population:
		var target = get_child(i)
		if target.TYPE == "unit":
			target.curve_rng()		
	
	
func is_there_a_hero_check():
	if Base.PLAYTEST == true:
		var population = get_child_count()
		var target
		for i in population:
			target = get_child(i)
			if target.TYPE == "unit" and target.HERO == true:
				return true
		return false
	
	return true
	
func is_there_a_unit_check():
	var population = get_child_count()
	var target
	for i in population:
		target = get_child(i)
		if target.TYPE == "unit":
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
		if target.TYPE == "unit" and target.my_damage_was_annuled == true:
			#target.refresh_me_from_being_annulled()
			if target.straight_target == null:
				target.curve_straight()
			else:
				push_error("attempted to refresh unit from anulment which had straight target")
			
		
		
		
func RIP_BOZO(target):
	#takes a void as target, reparents them to D12
	target.reparent(D12)		
	target.queue_free()
	
func make_child_replace_void(the_child, void_index):
	var target_void = get_child(void_index)
	RIP_BOZO(target_void)
	move_child(the_child,void_index)
		
		
func mass_second_ready():
	while spawning_units != 0:
		push_error("waiting to finish spawning before mass_second_readying")
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		
	push_error("mass secondreadying")
	var population = get_child_count()
	var target
	for i in range(population - 1, -1, -1): 
		target = get_child(i)
		if target.TYPE == "unit" and target.readied == false:
			target.second_ready()
	
func mass_reduce_cooldowns(how_much):
	push_error("mass cooldownreducing")
	var population = get_child_count()
	var target
	for i in range(population - 1, -1, -1): 
		target = get_child(i)
		if target.TYPE == "unit" and target.Passiveness == false:
			for j in how_much:
				target.Ability1.decrease_cooldown()	
		
		
		
