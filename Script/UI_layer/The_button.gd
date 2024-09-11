extends TextureButton

@onready var oblysk = $"../.."



@onready var UI_layer = $".."
@onready var graveyard_showcase = $"../Graveyard_showcase"
@onready var scrollh = %SCROLLH
@onready var camera_2d = %Camera2D
@onready var spawner = %Spawner
@onready var spawn_rect = $"../Spawner/SpawnRect"
@onready var player_mana_display = $"../Player_mana_display"

@onready var towerB1 = $"../../First_lane/Tower_layer/TowerB" #MOVE the tower1 to point to THE Tower1 and add TYPE, then continue with damageassigning abilities
@onready var towerA1 = $"../../First_lane/Tower_layer/TowerA"
@onready var tower_max_mana1 = $"../../First_lane/Tower_layer/TowerA/Mana_display/Max_mana"
@onready var tower_current_mana1 = $"../../First_lane/Tower_layer/TowerA/Mana_display/Current_mana"
@onready var card_layer1 = $"../../First_lane/Card_layer"
@onready var scrolla1 = $"../../First_lane/Card_layer/SCROLLA"
@onready var arena_rect1 = $"../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var scrollb1 = $"../../First_lane/Card_layer/SCROLLB"
@onready var abarena_rect1 = $"../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"

@onready var towerB2 = $"../../Mid_lane/Tower_layer/TowerB" 
@onready var towerA2 = $"../../Mid_lane/Tower_layer/TowerA"
@onready var tower_max_mana2 = $"../../Mid_lane/Tower_layer/TowerA/Mana_display/Max_mana"
@onready var tower_current_mana2 = $"../../Mid_lane/Tower_layer/TowerA/Mana_display/Current_mana"
@onready var card_layer2 = $"../../Mid_lane/Card_layer"
@onready var scrolla2 = $"../../Mid_lane/Card_layer/SCROLLA"
@onready var arena_rect2 = $"../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var scrollb2 = $"../../Mid_lane/Card_layer/SCROLLB"
@onready var abarena_rect2 = $"../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"

@onready var towerB3 = $"../../Last_lane/Tower_layer/TowerB" 
@onready var towerA3 = $"../../Last_lane/Tower_layer/TowerA"
@onready var tower_max_mana3 = $"../../Last_lane/Tower_layer/TowerA/Mana_display/Max_mana"
@onready var tower_current_mana3 = $"../../Last_lane/Tower_layer/TowerA/Mana_display/Current_mana"
@onready var card_layer3 = $"../../Last_lane/Card_layer"
@onready var scrolla3 = $"../../Last_lane/Card_layer/SCROLLA"
@onready var arena_rect3 = $"../../Last_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var scrollb3 = $"../../Last_lane/Card_layer/SCROLLB"
@onready var abarena_rect3 = $"../../Last_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"


var towerB   
var towerA  
var tower_max_mana 
var tower_current_mana
var card_layer 
var scrolla 
var arena_rect 
var scrollb 
var abarena_rect 




var towers = [towerA1, towerA2, towerA3, towerB1, towerB2, towerB3]







func _ready():
#	if spawn_rect.name == "SpawnRect":
#		push_error("THE_BUTTON_EXISTS")
#	else:
#		push_error("THE_BUTTON_doesnt exist yet")
	#I guess since there are so many nodes some script 
		#may run before all nodes are created
		
	Base.the_button = self
	#autoload script contains pointer to node that doesn't exist 
		#at game start
	
	new_lane()

func new_lane():
	match Base.current_lane:
		1:
			towerB = towerB1
			towerA = towerA1
			tower_max_mana = tower_max_mana1
			tower_current_mana = tower_current_mana1
			card_layer = card_layer1
			scrolla = scrolla1
			arena_rect = arena_rect1
			scrollb = scrollb1
			abarena_rect = abarena_rect1
		2:
			towerB = towerB2
			towerA = towerA2
			tower_max_mana = tower_max_mana2
			tower_current_mana = tower_current_mana2
			card_layer = card_layer2
			scrolla = scrolla2
			arena_rect = arena_rect2
			scrollb = scrollb2
			abarena_rect = abarena_rect2
		3:
			towerB = towerB3
			towerA = towerA3
			tower_max_mana = tower_max_mana3
			tower_current_mana = tower_current_mana3
			card_layer = card_layer3
			scrolla = scrolla3
			arena_rect = arena_rect3
			scrollb = scrollb3
			abarena_rect = abarena_rect3

func _on_pressed():
	if UI_layer.has_node("Tooltip_container"):
		var target = UI_layer.get_node("Tooltip_container")
		target.disappear_when_THE_BUTTON_is_pushed()
	#to get rid of tooltips
		
	print("unlocked? " + str(Base.CAN_CLICK_BUTTON_NOW))
	if  Base.Combat_phase == 0 and Base.CAN_CLICK_BUTTON_NOW == 1:
		Base.Main_phase = 0 #determines which curving to use, rng or anull
		# "when you can play cards"
		disabled = true
		if Base.current_lane == 4:
			await spawn_rect.deploy_all()
			await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
			global_prep_phase()
		if Base.current_lane != 4:
	#		card_layer.combat_phase_start()
			Base.Combat_phase = 1
			#So that graveyard doesnt update twice + other probly
			
			
			await THE_COMBAT()
			
			
			await get_tree().create_timer(card_layer.visible_death_anim_length).timeout
			
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
			await card_layer.clear_up_both()
			
			
			Base.Combat_phase = 0
			await card_layer.cleanup_phase()
			await card_layer.friday_phase()
			
			#NOT VIA an array, use nodes directly instead
			
			###################
			#NEW TURN STUFF HERE:
	#		await get_tree().create_timer(0.2).timeout
			
			

		
		move_to_next_lane()
		
#		if Base.current_lane == 4:
				
		Base.Main_phase = 1
		#disabled = false in move_to_next_lane()
			
	
func THE_COMBAT():
	var population = arena_rect.get_child_count()

	scrollb.SMASH()
	scrolla.SMASH()
	await get_tree().create_timer(0.35).timeout
	
	towerB.take_combat_damage()
	towerA.take_combat_damage()
	
	for i in range(population):
#		await get_tree().create_timer(0.5).timeout
#		THIS IS GONNA CAUSE ERRORS WHEN ONKILL APPEARS

		var T = population - (i+1)
		var Target_unit1 = arena_rect.get_child(T)
		var Target_unit2 = abarena_rect.get_child(T)
		if Target_unit1.TYPE == 0:
			Target_unit1.take_combat_damage()
		if Target_unit2.TYPE == 0:
			Target_unit2.take_combat_damage()
	
	
	
	
func move_to_next_lane():
	Base.move_to_next_lane()
	#takes care of CurrentLane integer
	if Base.current_lane < 4:
		spawner.visible = false
		#meaning game is moving from lane to another lane normally"
		camera_2d.move_camera_to_lane(Base.current_lane)
		
		oblysk.new_lane()
		new_lane()
		refresh_player_hp_dmg_to_be_taken()
		%SCROLLH.move_to_next_lane()
		%TextureButton.new_lane()
		
		global_check_cooldown_penetrability()
		
		await get_tree().create_timer(0.25).timeout
		#so that camera has time to get to new lane
		disabled = false
		
		await card_layer.monday_phase()
		#currently for kimmedi
#		await get_tree().create_timer(Base.FAKE_DELTA).timeout 
		await card_layer.tuesday_phase()
		#currently for duelyst
#		await get_tree().create_timer(Base.FAKE_DELTA).timeout 
		await card_layer.wednesday_phase()
		
		
		
	elif Base.current_lane == 4:
		#this is for end of round
		round_end()
		

		towerA.player_HP.new_damage_to_be_taken(0, towerA.name)
		towerB.player_HP.new_damage_to_be_taken(0, towerB.name)
		#so that it doesn't show someone is gonna take dmg
				
		camera_2d.move_camera_to_lane(Base.current_lane)
		spawn_rect.new_wave_of_creeps()
		spawn_rect.more_enemies()
		await graveyard_showcase.update_both()
		
		while spawn_rect.colliding_units != 0 or camera_2d.moving == true:
#			print("Button is waiting for collision of units in spawner to complete: " +str(spawn_rect.colliding_units))
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
		#wait until the units are collided
#		push_error("Button is NOT waiting for collision of units in spawner to complete: " +str(spawn_rect.colliding_units) +str(camera_2d.moving))
		spawner.visible = true



#######################################################################
###							GLOBALING   							###
#######################################################################


func global_prep_phase():
	card_layer1.prep_phase()
	card_layer2.prep_phase()
	card_layer3.prep_phase()
	
	if Base.current_lane != 4:
		Base.Main_phase = 1
	
func global_zoom_clicking_lanes_possible():
	card_layer1.make_zoom_clicking_lanes_possible()
	card_layer2.make_zoom_clicking_lanes_possible()
	card_layer3.make_zoom_clicking_lanes_possible()
	
func global_zoom_clicking_lanes_impossible():
	card_layer1.make_zoom_clicking_lanes_impossible()
	card_layer2.make_zoom_clicking_lanes_impossible()
	card_layer3.make_zoom_clicking_lanes_impossible()
	
	
func global_lane_is_being_picked(caller,faction):
	#caller is the covering that triggered this
	card_layer1.lane_is_being_picked(caller,faction)
	card_layer2.lane_is_being_picked(caller,faction)
	card_layer3.lane_is_being_picked(caller,faction)
	
func global_lane_is_no_longer_being_picked():
	card_layer1.lane_is_no_longer_being_picked()
	card_layer2.lane_is_no_longer_being_picked()
	card_layer3.lane_is_no_longer_being_picked()	
	
	
func global_lets_stop_targeting():
	card_layer1.lets_stop_targeting()
	card_layer2.lets_stop_targeting()
	card_layer3.lets_stop_targeting()
	%D12.lets_stop_targeting()
	
func global_lets_hide_abilities_and_items():
	card_layer1.lets_hide_abilities_and_items()
	card_layer2.lets_hide_abilities_and_items()
	card_layer3.lets_hide_abilities_and_items()
	
	
func global_lets_reshow_abilities_and_items():
	card_layer1.lets_reshow_abilities_and_items()
	card_layer2.lets_reshow_abilities_and_items()
	card_layer3.lets_reshow_abilities_and_items()
	#last to added during blinkaxe
	
func global_check_cooldown_penetrability():
	card_layer1.lets_check_cooldown_penetrability()
	card_layer2.lets_check_cooldown_penetrability()
	card_layer3.lets_check_cooldown_penetrability()
	#so that you can't active abilities and items off cooldown in other lanes
	
func global_lets_disconnect_abilities_and_items():
	card_layer1.lets_disconnect_abilities_and_items()
	card_layer2.lets_disconnect_abilities_and_items()
	card_layer3.lets_disconnect_abilities_and_items()
	
	
#######################################################################
###																	###
#######################################################################	
	
	
	
	
	
	
func refresh_player_hp_dmg_to_be_taken():
#	print(towerA.name)
	towerA.visualise_health_loss()
	towerB.visualise_health_loss()










func round_end():
	player_mana_display.increase_max_mana()
	transfer_tower_mana_to_player_mana()
	round_end_signal()
	
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
	
	round_start()

func round_start():
	scrollh.draw_cards(2)
	
	tower_max_mana1.increase_max_mana(1)
	tower_current_mana1.refill_mana()
	tower_max_mana2.increase_max_mana(1)
	tower_current_mana2.refill_mana()
	tower_max_mana3.increase_max_mana(1)
	tower_current_mana3.refill_mana()

func transfer_tower_mana_to_player_mana():
	var mana1 = tower_current_mana1.current_mana
	var mana2 = tower_current_mana2.current_mana
	var mana3 = tower_current_mana3.current_mana
	var mana_to_be_added = (mana1 + mana2 + mana3)/3
	player_mana_display.increase_mana(mana_to_be_added)



#######################################################################
###							SIGNALHUBBING							###
#######################################################################

var round_end_signal_list = []

func round_end_signal():
	for i in range(round_end_signal_list.size() - 1, -1, -1):
		var target = round_end_signal_list[i]
		if target != null:
				target.round_end()
		else: 
			round_end_signal_list.remove_at(i)
