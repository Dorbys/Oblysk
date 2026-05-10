extends Control

@onready var graveyard_showcase = $"../../UI_layer/Graveyard_showcase"
@onready var dead_heroes = $"../../UI_layer/Graveyard_showcase/Dead_heroes"


@onready var arena_rect = $"SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect = $"SCROLLB/Abarena/SIZECHECK/ArenaRect"
#@onready var dead_heroesB = $"../UI_layer/Graveyard_showcase/Dead_heroesB"
@export var VOID = PackedScene
@onready var tower_layer = $"../Tower_layer"
@onready var tower_a = $"../Tower_layer/TowerA"
@onready var tower_b = $"../Tower_layer/TowerB"
@onready var lane_buildings_A = $"../Tower_layer/TowerA/Buildings"
@onready var lane_buildings_B = $"../Tower_layer/TowerB/Buildings"

@onready var spawn_rect = $"../../UI_layer/Spawner/SpawnRect"
#just for rpcing during monday phase to joiner that deployment is done
@onready var the_button = $"../../UI_layer/THE_BUTTON"
	#also rpcing monday, once monday effects complete

var my_lane 
	#calced in ready() of arena_rect

#var VOIDTYPE = 7
var Targeting_now = 0

#var Mirror = []
func slot_care(node):
	#might try deleting this 
	if node.VOIDING == 0:
		pass
	else :
		var wheretf = node.get_index()
		var parentus = node.get_parent()
#		if wheretf >= Mirror.size():
		if parentus == arena_rect:
#			print(Mirror)
			if abarena_rect.get_child_count() > wheretf:
#				if abarena_rect.get_child(wheretf).TYPE != 0:
#				print("Option more:<<<<<<")
				if node.Replaced_a_void == 0:
#					print(wheretf)
					abarena_rect.insert_void(wheretf,0,0)
#					Mirror.insert(wheretf, [node.TYPE, VOIDTYPE])
			
			elif abarena_rect.get_child_count() == wheretf:
#				if abarena_rect.get_child(wheretf).TYPE != 0:
					abarena_rect.insert_void(wheretf,0,0)
#					print("Option equals<<<<<<")
#					Mirror.append([node.TYPE, VOIDTYPE])
			
			elif (abarena_rect.get_child_count()) < wheretf:
				if node.Replaced_a_void == 0:
					abarena_rect.insert_void(wheretf,0,0)
#					Mirror.append([node.TYPE, VOIDTYPE])
#					print("Hope this gcc can't happen<<<<<<")
#					print(str(wheretf) + str(abarena_rect.get_child_count()))
				
			else: push_error("Abarena gcc error<<<<<<<<<<<<")
				
			
			
			
		elif parentus == abarena_rect:
			
#			print(Mirror)
			if arena_rect.get_child_count() > wheretf:
#				if arena_rect.get_child(wheretf).TYPE != 0:7
#				print("Option more:<<<<<<")
				if node.Replaced_a_void == 0:
					arena_rect.insert_void(wheretf,0,0)
#					print(wheretf)
#					Mirror.insert(wheretf, [VOIDTYPE, node.TYPE])
					
			elif arena_rect.get_child_count() == wheretf:
#				if arena_rect.get_child(wheretf).TYPE != 0:
					arena_rect.insert_void(wheretf,0,0)
#					print("Option equals<<<<<<")
#					Mirror.append([VOIDTYPE, node.TYPE])		
					
					
			elif arena_rect.get_child_count()-1 < wheretf:
				if node.Replaced_a_void == 0:
					arena_rect.insert_void(wheretf,0,0)
#					Mirror.append([VOIDTYPE, node.TYPE])
#					print("Hope this gcc can't happen<<<<<<")
#					print(wheretf)
					await get_tree().create_timer(0.25).timeout

#					print(arena_rect.get_child_count()-1)
				
				
			else: push_error("Abarena gcc error<<<<<<<<<<<<")
		#To make sure first is arena rect type and THEN abarena
		
		
		
		else: push_error("UNKOWN PARENT DETECTEEEEEEEEEEEEED")
		
			
				
var dead_id = 0				
func Hero_death_care(node, identification, parent):
	await parent.replace_me_by_void(node,identification, 1,1,1)	
	if Base.Combat_phase == 0:
		parent.maybe_clean_two_voids(identification)


#	if parent == arena_rect:
#		var opposite = abarena_rect.get_child(identification)
#		if opposite.TYPE == "unit and opposite.HealthC>0:
##			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			parent.insert_void(identification,1,1)
#			abarena_rect.collide_units()
#
#
#		elif opposite.TYPE == "unit:
#			pass
#
#		else:
#			opposite.queue_free()
##			node.queue_free()
#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			Double_collide()
#
#	elif parent == abarena_rect:
#		var opposite = arena_rect.get_child(identification)
#		if opposite.TYPE == "unit and opposite.HealthC>0:
##			node.queue_free()
##			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			parent.insert_void(identification,1,1)
#			arena_rect.collide_units()
#
#		elif opposite.TYPE == "unit:
#			pass
#
#		else:
#			opposite.queue_free()
##			node.queue_free()
#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			Double_collide()
			
func Death_care(node, identification, parent):
	#enough for dueling to decrease the HealthC of opposite
	parent.replace_me_by_void(node,identification, 0,1,1) #hmmmmmm
	
	if Base.Combat_phase == 0:
		parent.maybe_clean_two_voids(identification)
#	if parent == arena_rect:
#		var opposite = abarena_rect.get_child(identification)
#		if opposite.TYPE == "unit and opposite.HealthC>0:
##			print("My alive oppposite is: "+ str(opposite.get_index()))
#			node.queue_free()
#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			parent.insert_void(identification,1,1)
#			abarena_rect.collide_units()
#
#		elif opposite.TYPE == "unit:
#			node.queue_free()
#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			arena_rect.collide_units()
#
#		else:
##			print("My oppposite is: "+ str(opposite.get_index()))
#			opposite.queue_free()
#			node.queue_free()
#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			Double_collide()
#
#	elif parent == abarena_rect:
#		var opposite = arena_rect.get_child(identification)
#		if opposite.TYPE == "unit and opposite.HealthC>0:
##			print("My alive ABoppposite is: "+ str(opposite.get_index()))
#			node.queue_free()
#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			parent.insert_void(identification,1,1)
#			arena_rect.collide_units()
#
#		elif opposite.TYPE == "unit:
#			node.queue_free()
#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			abarena_rect.collide_units()
#
#		else:
##			print("My ABoppposite is: "+ str(opposite.get_index()))
#			opposite.queue_free()
#			node.queue_free()
#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			Double_collide()
		
				
				
func lets_target_a_unit(caller):
	Targeting_now = 1
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit":
			target.Im_clickable(caller)			
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == "unit":
			target.Im_clickable(caller)		

func lets_stop_targeting():
	Targeting_now = 0
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit":
			target.Im_no_longer_clickable()			
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == "unit":
			target.Im_no_longer_clickable()		
			
			
func lets_hide_abilities_and_items():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit":
#			print("reshowing abilities")
			target.hide_ability_and_items_mb()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == "unit":
			target.hide_ability_and_items_mb()	
			
func lets_reshow_abilities_and_items():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit":
#			print("reshowing abilities")
			target.reshow_ability_and_items_mb()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == "unit":
			target.reshow_ability_and_items_mb()	
	
func lets_disconnect_abilities_and_items():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit":
#			print("reshowing abilities")
			target.disconnect_ability_and_items_mb()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == "unit":
			target.disconnect_ability_and_items_mb()	
			
func lets_reconnect_abilities_and_items():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit":
#			print("reshowing abilities")
			target.reconnect_ability_and_items_mb()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == "unit":
			target.reconnect_ability_and_items_mb()
				
func lets_reshow_abilities():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit":
#			print("reshowing abilities")
			target.reshow_ability()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == "unit":
			target.reshow_ability()	
			
func lets_lvlup(XP, caller):
#	print("letslvlup with " + str(XP) +" xp")
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit" and target.HERO == true:
			target.show_I_can_lvlup(XP, caller)	
		var target2 = abarena_rect.get_child(i)
		if target2.TYPE == "unit" and target2.HERO == true:
			target2.show_I_can_lvlup(XP, caller)	
		
func card_preview_targeting_non_single_exits_tree():				
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	if Targeting_now == 0:
		arena_rect.a_spell_is_no_longer_being_dragged()
		abarena_rect.a_spell_is_no_longer_being_dragged()		
				
				
				

	
func dueling(Target_unit1, Target_unit2):
	var attack1 = Target_unit1.AttackC - Target_unit2.Unit_Armor
	var attack2 = Target_unit2.AttackC - Target_unit1.Unit_Armor #CURRENT IMPLLLLLLLL

	Target_unit1.take_damage(attack2)
	#Once graveyard for units is added, this should no longer be needed
	#hero_death_Care in CardLayer can manage heroes dying at the "same" time
	Target_unit2.take_damage(attack1)				
				
				
				
				
				
				
				
func Double_collide():
	arena_rect.collide_units()	
	abarena_rect.collide_units()			
				
func clear_up_both():
	var ACC = arena_rect.get_child_count()
	var cleansed = false
	for i in ACC:
		var T = ACC - (i+1)
		var A1 = arena_rect.get_child(T)
		var B1 = abarena_rect.get_child(T)	
		if A1.TYPE == "void" and B1.TYPE == "void":	
			cleansed = true
			A1.queue_free()
			B1.queue_free()
	if cleansed == true:
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		Double_collide()
			
func combat_phase_start():
	Base.Combat_phase = 1
	
func combat_phase_end():
	Base.Combat_phase = 0
				
func cleanup_phase():
	await tower_layer.cleanup_phase_signal()
	await apply_phase("cleanup_phase")
	
	
func prep_phase():
	
	await tower_layer.unit_order_changed_signal(my_lane)
	await apply_phase("before_prep_phase")
	await annul_tower_damage_to_be_done()
	await apply_phase("prep_phase")
	
func monday_phase():
	if Lobby.MULTIPLAYER == true and Lobby.host == true:
		
		spawn_rect.rpc_joiner_deployment_is_ready()
	push_error("monday phase")
	await tower_layer.monday_phase_signal()
	await get_tree().create_timer(0.3).timeout 
	the_button.monday_completed()
	

func tuesday_phase():
	push_error("tuesday phase")
	await tower_layer.tuesday_phase_signal()
func wednesday_phase():
	await tower_layer.wednesday_phase_signal()

	
func friday_phase():
	await tower_layer.friday_phase_signal()
			
func apply_phase(phase):
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit":
			await target.call(phase)				
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == "unit":
			await target.call(phase)		
				
func annul_tower_damage_to_be_done():
	tower_a.increase_damage_to_be_taken(-tower_a.damage_to_be_taken)
	tower_b.increase_damage_to_be_taken(-tower_b.damage_to_be_taken)
				
func ability_is_looking_for_targets_visual():
	arena_rect.TargetingSpell = 1
	abarena_rect.TargetingSpell = 1			

func curve_rng_both():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit":
			target.curve_straight #curve_rng()				
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == "unit":
			target.curve_straight() #curve_rng()	



func refresh_lane_auras(target,faction,wielder):
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	#waiting for a building to queue free possibly
	lane_buildings_A.refresh_aura(target,faction, wielder)
	lane_buildings_B.refresh_aura(target,faction, wielder)

			
func unit_being_sieged(faction, siege_dmg):
	#push_error("siege dmg is: " +str(siege_dmg))
	match faction:
		"alpha":
			tower_a.increase_damage_to_be_taken(siege_dmg)
		"beta":
			tower_b.increase_damage_to_be_taken(siege_dmg)	
		_:
			print("faction in unit_being_sieged doesnt match again")	
	
func unit_no_longer_being_sieged(faction, siege_dmg):
	push_error("UN siege dmg is: " +str(siege_dmg))
	match faction:
		"alpha":
			tower_a.increase_damage_to_be_taken(-siege_dmg)
		"beta":
			tower_b.increase_damage_to_be_taken(-siege_dmg)
	
	
	
func lane_aura_check_both():
	var population = arena_rect.get_child_count()
	for i in population:
		var target1 = arena_rect.get_child(i)
		var target2 = abarena_rect.get_child(i)
		if target1.TYPE == "unit":
			target1.lane_aura_check()
		if target2.TYPE == "unit":
			target2.lane_aura_check()
	
	
	
	

func make_zoom_clicking_lanes_possible():
	%Click_to_zoom_here.visible = true
	
func make_zoom_clicking_lanes_impossible():
	%Click_to_zoom_here.visible = false
	
func lane_is_being_picked(caller,faction):
	%Lane_picker.reshow_myself(caller,faction)
	
func lane_is_no_longer_being_picked():
	%Lane_picker.hide_myself()



func lets_check_cooldown_penetrability():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == "unit":
#			print("reshowing abilities")
			target.check_cooldown_penetrability()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == "unit":
			target.check_cooldown_penetrability()	
			
			
func get_lane(lane_identification:String):
	#for lanes: MY_identity+my_lane
	var identity = lane_identification.substr(0,1)
	var lane_int = lane_identification.substr(1)
	push_error("identity: " +str(identity) +" my_lane: " +str(lane_int))
	var target_card_layer
	var target_lane
	match lane_int:
		"1":
			target_card_layer = $"../../First_lane/Card_layer"
		"2":
			target_card_layer = $"../../Mid_lane/Card_layer"	
		"3":
			target_card_layer = $"../../Last_lane/Card_layer"	
		_:
			push_error("incorrect my_lane value: " +str(lane_int))
	if identity == "A":
		target_lane = target_card_layer.arena_rect	
	elif identity == "B":
		target_lane = target_card_layer.abarena_rect
	else:
		push_error("unknown lane identity: " +identity)
			
	return target_lane		
			
#================================================================
#						SYNCING
#================================================================
	#when unit curves or something is played on a unit, I need
		#to replicate the effect for opponent
		#since different treepaths, units can't RPC
	
#@rpc("any_peer", "call_remote", "reliable")
#func make_mirror_unit_curve(direction, unique_key:int):
	##only from host to join, hmm
	#if multiplayer.get_remote_sender_id() == 0:
		##if I was called localy
		#rpc_id(Lobby.opponent_peer_id, "make_mirror_unit_curve", direction, unique_key)
	#else:
		##if I was RPCed
##		push_error("get_remote_sender_id s mp funguje")
		#var fun_to_call = "curve_" + direction
		#Lobby.universal_global_unit_array[unique_key].call(fun_to_call)
			
@rpc("any_peer", "call_remote", "reliable")
func make_mirror_unit_receive_spell_call(spelltype:String,
 spell_id:int, unique_key:int, concurrent_player:String):			
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "make_mirror_unit_receive_spell_call",
		 spelltype,spell_id,unique_key,concurrent_player)
		push_error("sending function: " + str(spell_id) +" to unit " +str(unique_key))
	else:
		var DB = SpellsDB
		var DB_full = SpellsDB.SPELLS_DB
		if spelltype == "lvlup_spell":
			DB = LvlupDB
			DB_full = LvlupDB.LVLUPS_DB
		var fun_to_call:String = DB_full[spell_id][0]
		var unit_to_target = Lobby.universal_global_unit_array[unique_key]
		DB.call(fun_to_call, unit_to_target, concurrent_player, true)
		push_error("calling function: " +fun_to_call +" " +"on unit " +str(unique_key))

@rpc("any_peer", "call_remote", "reliable")
func make_two_mirror_units_receive_spell_call(cardtype:String,
 func_to_call:String, first_unit_unique_key:int, second_unit_unique_key:int, sync_data):
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "make_two_mirror_units_receive_spell_call",
		 cardtype,func_to_call,first_unit_unique_key,second_unit_unique_key, sync_data)
		push_error("sending function: " +func_to_call +" to units " +str(first_unit_unique_key,second_unit_unique_key))
	else:
		var DB = SpellsDB
		if cardtype == "lvlup_spell":
			DB = LvlupDB
		elif cardtype == "item":
			DB = ItemsDB

		var target1 = Lobby.universal_global_unit_array[first_unit_unique_key]
		var target2 = Lobby.universal_global_unit_array[second_unit_unique_key]
		DB.call(func_to_call, target1, target2, sync_data)
		push_error("calling function: " + func_to_call +" " +"on units " +str(first_unit_unique_key,second_unit_unique_key))		
			
		
@rpc("any_peer", "call_remote", "reliable")		
func make_my_mirror_unit_equip_item(item_ID:int, unit_unique_key:int):
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "make_my_mirror_unit_equip_item",
		 item_ID,unit_unique_key)
		push_error("sending equip command: " + str(item_ID) +" " +"to unit " +str(unit_unique_key))
	else:
		Lobby.universal_global_unit_array[unit_unique_key].equip_item(item_ID)
		push_error("equipping item: " + str(item_ID) +" " +"to unit " +str(unit_unique_key))

@rpc("any_peer", "call_remote", "reliable")		
func make_my_mirror_unit_lvlup(unit_unique_key:int):
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "make_my_mirror_unit_lvlup", unit_unique_key)
		push_error("sending rpc to lvlup unit " +str(unit_unique_key))
	else:
		Lobby.universal_global_unit_array[unit_unique_key].pretend_LVLUP()
		push_error("lvlupping unit " +str(unit_unique_key))
		
@rpc("any_peer", "call_remote", "reliable")		
func make_my_mirror_unit_receive_ability_call(unit_unique_key:int, funcall:String):
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "make_my_mirror_unit_receive_ability_call", unit_unique_key, funcall)
		push_error("sending rpc to receive ability_call to unit " +str(unit_unique_key) +" " +funcall)
	else:
		AbilitiesDB.call(funcall,Lobby.universal_global_unit_array[unit_unique_key])
		push_error("unit receiving abilitycall " +str(unit_unique_key))
	
#kinda no point in having the "unit" in make_my_mirror_unit
	
	
@rpc("any_peer", "call_remote", "reliable")		
func make_my_mirror_minus_hp(unit_unique_key:int):
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "make_my_mirror_minus_hp", unit_unique_key)
		push_error("sending rpc to minus hp unit " +str(unit_unique_key))
	else:
		Lobby.universal_global_unit_array[unit_unique_key].minus_hp(false)
		push_error("minus_HPing unit " +str(unit_unique_key))
		
@rpc("any_peer", "call_remote", "reliable")		
func make_my_mirror_plus_hp(unit_unique_key:int):
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "make_my_mirror_plus_hp", unit_unique_key)
		push_error("sending rpc to plus hp unit " +str(unit_unique_key))
	else:
		Lobby.universal_global_unit_array[unit_unique_key].plus_hp(false)
		push_error("plus_HPing unit " +str(unit_unique_key))
		
@rpc("any_peer", "call_remote", "reliable")
func make_mirror_lane_receive_spell_call(spelltype:String,
 fun_to_call:String, concurrent_player:String):
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "make_mirror_lane_receive_spell_call",
		 spelltype,fun_to_call,concurrent_player)
		push_error("sending function: " + fun_to_call +" to lane " + self.name)
	else:
		var DB = SpellsDB
		if spelltype == "lvlup_spell":
			DB = LvlupDB
		DB.call(fun_to_call, arena_rect, concurrent_player, true) 
		push_error("calling function: " + fun_to_call +" on lane " + self.name)		

@rpc("any_peer", "call_remote", "reliable")
func make_mirror_unit_and_lane_receive_spell_call(card_type:String, func_to_call:String,
		target1_MY_UNIQUE_UNIT_KEY:int, target2_lane_identification:String, sync_data):
	#target2_lane_identification: MY_identity+my_lane
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "make_mirror_unit_and_lane_receive_spell_call",
		 card_type,func_to_call,target1_MY_UNIQUE_UNIT_KEY,target2_lane_identification, sync_data)
	else:
		var DB = SpellsDB
		if card_type == "lvlup_spell":
			DB = LvlupDB
		elif card_type == "item":
			DB = ItemsDB
		var target_lane = get_lane(target2_lane_identification)
		DB.call(func_to_call,Lobby.universal_global_unit_array[target1_MY_UNIQUE_UNIT_KEY],
			target_lane, sync_data, true)

@rpc("any_peer", "call_remote", "reliable")
func make_mirror_lane_building(building_id:int,):
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "make_mirror_lane_building",
		 building_id)
		push_error("sending building command: " + str(building_id))
	else:
		lane_buildings_B.make_building(building_id)
		#currently only B
		
@rpc("any_peer", "call_remote", "reliable")
func mirror_item_activate_cooldown(unit_unique_key:int, item_slot:String):
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "mirror_item_activate_cooldown",
		 unit_unique_key, item_slot)
		push_error("sending activate item cooldown to " + str(unit_unique_key))
	else:
		var target_slot = Lobby.universal_global_unit_array[unit_unique_key].get_node(item_slot)
		target_slot.activate_cooldown(true)
	
@rpc("any_peer", "call_remote", "reliable")
func mirror_ability_activate_cooldown(unit_unique_key:int):
	#separate func cuz tree diff
	if multiplayer.get_remote_sender_id() == 0:
		rpc_id(Lobby.opponent_peer_id, "mirror_ability_activate_cooldown",
		 unit_unique_key)
		#push_error("sending activate ability cooldown to " + str(unit_unique_key))
	else:
		var target_hero = Lobby.universal_global_unit_array[unit_unique_key]
		while target_hero == null:
			#push_error("waiting for mirror ability cooldown to find target hero")
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
			target_hero = Lobby.universal_global_unit_array[unit_unique_key]
		var target_slot = target_hero.Ability1
		target_slot.activate_cooldown(true)
