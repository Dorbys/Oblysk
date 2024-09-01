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
@onready var lane_auras_A = $"../Tower_layer/TowerA/Buildings"
@onready var lane_auras_B = $"../Tower_layer/TowerB/Buildings"


var my_lane 
	#calced in ready() of arena_rect

var VOIDTYPE = 7
var Targeting_now = 0

#var Mirror = []
func slot_care(node):
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
#		if opposite.TYPE == 0 and opposite.HealthC>0:
##			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			parent.insert_void(identification,1,1)
#			abarena_rect.collide_units()
#
#
#		elif opposite.TYPE == 0:
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
#		if opposite.TYPE == 0 and opposite.HealthC>0:
##			node.queue_free()
##			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			parent.insert_void(identification,1,1)
#			arena_rect.collide_units()
#
#		elif opposite.TYPE == 0:
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
#		if opposite.TYPE == 0 and opposite.HealthC>0:
##			print("My alive oppposite is: "+ str(opposite.get_index()))
#			node.queue_free()
#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			parent.insert_void(identification,1,1)
#			abarena_rect.collide_units()
#
#		elif opposite.TYPE == 0:
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
#		if opposite.TYPE == 0 and opposite.HealthC>0:
##			print("My alive ABoppposite is: "+ str(opposite.get_index()))
#			node.queue_free()
#			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			parent.insert_void(identification,1,1)
#			arena_rect.collide_units()
#
#		elif opposite.TYPE == 0:
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
		if target.TYPE == 0:
			target.Im_clickable(caller)			
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == 0:
			target.Im_clickable(caller)		

func lets_stop_targeting():
	Targeting_now = 0
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == 0:
			target.Im_no_longer_clickable()			
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == 0:
			target.Im_no_longer_clickable()		
			
			
func lets_hide_abilities_and_items():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == 0:
#			print("reshowing abilities")
			target.hide_ability_and_items_mb()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == 0:
			target.hide_ability_and_items_mb()	
			
func lets_reshow_abilities_and_items():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == 0:
#			print("reshowing abilities")
			target.reshow_ability_and_items_mb()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == 0:
			target.reshow_ability_and_items_mb()	
	
func lets_disconnect_abilities_and_items():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == 0:
#			print("reshowing abilities")
			target.disconnect_ability_and_items_mb()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == 0:
			target.disconnect_ability_and_items_mb()	
			
func lets_reconnect_abilities_and_items():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == 0:
#			print("reshowing abilities")
			target.reconnect_ability_and_items_mb()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == 0:
			target.reconnect_ability_and_items_mb()
				
func lets_reshow_abilities():
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == 0:
#			print("reshowing abilities")
			target.reshow_ability()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == 0:
			target.reshow_ability()	
			
func lets_lvlup(XP, caller):
#	print("letslvlup with " + str(XP) +" xp")
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == 0 and target.HERO == 1:
			target.show_I_can_lvlup(XP, caller)	
		var target2 = abarena_rect.get_child(i)
		if target2.TYPE == 0 and target2.HERO == 1:
			target2.show_I_can_lvlup(XP, caller)	
		
func card_preview_targeting_non_single_exits_tree():				
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	if Targeting_now == 0:
		arena_rect.a_spell_is_no_longer_being_dragged()
		abarena_rect.a_spell_is_no_longer_being_dragged()		
				
				
				
var visible_death_anim_length = 0.6
var death_anim_length = 0.9
	
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
		if A1.TYPE == 7 and B1.TYPE == 7:	
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
	await tower_layer.monday_phase_signal()
func tuesday_phase():
	await tower_layer.tuesday_phase_signal()
func wednesday_phase():
	await tower_layer.wednesday_phase_signal()

	
func friday_phase():
	await tower_layer.friday_phase_signal()
			
func apply_phase(phase):
	for i in arena_rect.get_child_count():
		var target = arena_rect.get_child(i)
		if target.TYPE == 0:
			await target.call(phase)				
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == 0:
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
		if target.TYPE == 0:
			target.curve_rng()				
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == 0:
			target.curve_rng()	



func refresh_lane_auras(target,faction,wielder):
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	#waiting for a building to queue free possibly
	lane_auras_A.refresh_aura(target,faction, wielder)
	lane_auras_B.refresh_aura(target,faction, wielder)

			
func unit_being_sieged(faction, siege_dmg):
	print("siege dmg is: " +str(siege_dmg))
	match faction:
		"alpha":
			tower_a.increase_damage_to_be_taken(siege_dmg)
		"beta":
			tower_b.increase_damage_to_be_taken(siege_dmg)	
		_:
			print("faction in unit_being_sieged doesnt match again")	
	
func unit_no_longer_being_sieged(faction, siege_dmg):
	print("UN siege dmg is: " +str(siege_dmg))
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
		if target1.TYPE == 0:
			target1.lane_aura_check()
		if target2.TYPE == 0:
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
		if target.TYPE == 0:
#			print("reshowing abilities")
			target.check_cooldown_penetrability()
	for i in abarena_rect.get_child_count():
		var target = abarena_rect.get_child(i)
		if target.TYPE == 0:
			target.check_cooldown_penetrability()	
