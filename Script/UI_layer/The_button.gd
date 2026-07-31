extends TextureButton

@onready var oblysk = $"../.."



@onready var UI_layer = $".."
@onready var graveyard_showcase = $"../Graveyard_showcase"
@onready var scrollh = %SCROLLH
@onready var camera_2d = %Camera2D
@onready var spawner = %Spawner
@onready var spawn_rect = $"../Spawner/SpawnRect"
@onready var opponent_spawn_rect = $"../Spawner/Opponent_spawn_rect_fake"
@onready var passing_status_indicator = $"../DevTools/Passing_status_indicator"
@onready var game_over: Control = %Game_over


@onready var player_mana_display = $"../Player_mana_display"
@onready var opponent_mana = $"../Opponent_info/Opponent_mana"
@onready var opponent_turn_indicator = $"../Opponent_info/Opponent_turn_indicator"
@onready var player_hp = %Player_HP


@onready var towerB1 = $"../../First_lane/Tower_layer/TowerB" #MOVE the tower1 to point to THE Tower1 and add TYPE, then continue with damageassigning abilities
@onready var towerA1 = $"../../First_lane/Tower_layer/TowerA"
@onready var tower_max_mana1 = $"../../First_lane/Tower_layer/TowerA/Mana_display/Max_mana"
@onready var tower_current_mana1 = $"../../First_lane/Tower_layer/TowerA/Mana_display/Current_mana"
@onready var tower_current_mana1B = $"../../First_lane/Tower_layer/TowerB/Mana_display/Current_mana"
@onready var card_layer1 = $"../../First_lane/Card_layer"
@onready var scrolla1 = $"../../First_lane/Card_layer/SCROLLA"
@onready var arena_rect1 = $"../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var scrollb1 = $"../../First_lane/Card_layer/SCROLLB"
@onready var abarena_rect1 = $"../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"

@onready var towerB2 = $"../../Mid_lane/Tower_layer/TowerB" 
@onready var towerA2 = $"../../Mid_lane/Tower_layer/TowerA"
@onready var tower_max_mana2 = $"../../Mid_lane/Tower_layer/TowerA/Mana_display/Max_mana"
@onready var tower_current_mana2 = $"../../Mid_lane/Tower_layer/TowerA/Mana_display/Current_mana"
@onready var tower_current_mana2B = $"../../Mid_lane/Tower_layer/TowerB/Mana_display/Current_mana"
@onready var card_layer2 = $"../../Mid_lane/Card_layer"
@onready var scrolla2 = $"../../Mid_lane/Card_layer/SCROLLA"
@onready var arena_rect2 = $"../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var scrollb2 = $"../../Mid_lane/Card_layer/SCROLLB"
@onready var abarena_rect2 = $"../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"

@onready var towerB3 = $"../../Last_lane/Tower_layer/TowerB" 
@onready var towerA3 = $"../../Last_lane/Tower_layer/TowerA"
@onready var tower_max_mana3 = $"../../Last_lane/Tower_layer/TowerA/Mana_display/Max_mana"
@onready var tower_current_mana3 = $"../../Last_lane/Tower_layer/TowerA/Mana_display/Current_mana"
@onready var tower_current_mana3B = $"../../Last_lane/Tower_layer/TowerB/Mana_display/Current_mana"
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




var towers

var confirmed_my_deployment = false
var opponent_confirmed_deployment = false

var monday_received = false
var opponent_monday_received = false
	#to sync days since they're rpced over




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
	#Base.game_started_yet_bruh = true
		#now in spawner INITIATE_THE_GAME()
	
		
	#set_process(false)
	#multiplayer deployment coordination tool
	#turned off even in SP cuz it's played by default
	
	towers = [towerA1, towerA2, towerA3, towerB1, towerB2, towerB3]
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
	if disabled:
		pass
		#using keyboard was able to overcome the disable
	elif Lobby.MULTIPLAYER == true:
		if Base.current_lane == 4:
			if confirmed_my_deployment == false:
				confirm_my_deployment()
				Base.return_granted_action_for_lane4()
				
		elif Base.initiative == 1:
			Base.grant_an_action()
			if Base.passing == false:
				handle_MP_thursday()
		else:
			handle_MP_thursday()
			#since thursday is the combat phase aka afterpass
	else: the_button_has_been_pressed_frfr()
		
func handle_MP_thursday():
	#only called in MP
	#if Lobby.host == true:
	the_button_has_been_pressed_frfr()
	await get_tree().create_timer(Base.FAKE_OMEGA).timeout
	rpc_id(Lobby.opponent_peer_id, "the_button_has_been_pressed_frfr")
	#else:
		#rpc_id(Lobby.opponent_peer_id, "the_button_has_been_pressed_frfr")
		#await get_tree().create_timer(Base.FAKE_OMEGA).timeout
		#the_button_has_been_pressed_frfr()
		
@rpc("any_peer", "call_remote", "reliable")
func the_button_has_been_pressed_frfr():
	if UI_layer.has_node("Tooltip_container"):
		var target = UI_layer.get_node("Tooltip_container")
		target.disappear_when_THE_BUTTON_is_pushed()
	#to get rid of tooltips
	
	push_error("unlocked? " + str(Base.CAN_CLICK_BUTTON_NOW))
	
	if  Base.Combat_phase == false and (Base.CAN_CLICK_BUTTON_NOW == 1 or multiplayer.get_remote_sender_id() != 0):
		Base.Main_phase = 0 
		disable_me()
		opponent_turn_indicator.inactive_texture_now()
		if Base.current_lane == 4:
			if Lobby.MULTIPLAYER == true:
				if Lobby.host == true:
					#If I'm the host
					await spawn_rect.deploy_all()
					
				elif Lobby.host == false:
					await spawn_rect.clear_creeps()
					#await spawn_rect.wait_for_host_to_rpc_me_deployment()
						#this waiting is done in process()
					

			
					
			else: await spawn_rect.deploy_all()
			
			await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
			global_prep_phase()
		elif Base.current_lane != 4:
	#		card_layer.combat_phase_start()
			Base.Combat_phase = true
			#So that graveyard doesnt update twice + other probly
			
			
			await THE_COMBAT()
			
			
			await get_tree().create_timer(Base.visible_death_anim_length).timeout
			
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
			await card_layer.clear_up_both()
			
			
			Base.Combat_phase = false
			
			if game_over.game_over_check():
				return 0
			
			await card_layer.cleanup_phase()
			await card_layer.day_x_phase("friday")
			

			
			

		
		await move_to_next_lane()
		
#		if Base.current_lane == 4:
				
		Base.Main_phase = 1

		
	
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
		if Target_unit1.TYPE == "unit":
			Target_unit1.take_combat_damage()
		if Target_unit2.TYPE == "unit":
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
		
			
		
		await card_layer.passive_phase()
		
		await card_layer.day_x_phase("monday")
		if Lobby.MULTIPLAYER == true:
			await waiting_for_MP_monday_to_finish()
#		await get_tree().create_timer(Base.FAKE_DELTA).timeout 
		await card_layer.day_x_phase("tuesday")
		if Lobby.MULTIPLAYER == true:
			monday_MP_passed()
		#currently for duelyst
#		await get_tree().create_timer(Base.FAKE_DELTA).timeout 
		await card_layer.day_x_phase("wednesday")
		
		if Lobby.MULTIPLAYER == false:
			#mp takes care of it in Base 
				#which is trigged in next collumn 2 if statement
			await get_tree().create_timer(Base.death_anim_length)
			enable_me()
		
		
		
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
		
		while spawn_rect.colliding_units != 0 and opponent_spawn_rect.colliding_units != 0 and camera_2d.moving == true:
#			print("Button is waiting for collision of units in spawner to complete: " +str(spawn_rect.colliding_units))
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
		#wait until the units are collided
#		push_error("Button is NOT waiting for collision of units in spawner to complete: " +str(spawn_rect.colliding_units) +str(camera_2d.moving))
		spawner.visible = true
		spawn_rect._on_child_order_changed()
		
		
	if Lobby.MULTIPLAYER == true:
		if Base.current_lane == 4:
			spawn_rect.lane_4_start()
		elif Base.current_lane != 4:		
			if Base.initiative == 1:
				await get_tree().create_timer(Base.death_anim_length).timeout
				Base.receive_granted_action()
			else:
				Base.granted_action = 0
				await get_tree().create_timer(Base.death_anim_length).timeout
				Base.refresh_pass_button()
				show_opponent_turn_begins()

func waiting_for_MP_monday_to_finish():
	push_error("waiting for MP monday to finish")
	while monday_received == false or opponent_monday_received == false:
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
	push_error("waiting for MP monday completed")
	#so that player doesnt go to tuesday before monday finishes and is rpced over
	
func monday_MP_passed():
	monday_received = false
	opponent_monday_received = false
	
	
var game_starting_monday_completed:bool = false	
@rpc("any_peer", "call_remote", "reliable")	
func monday_completed():
	if multiplayer.get_remote_sender_id() == 0:
		#push_error("My monday finished")
		monday_received = true
		rpc_id(Lobby.opponent_peer_id, "monday_completed")
		if Lobby.MULTIPLAYER and Lobby.host and not game_starting_monday_completed:
			spawn_rect.rpc_joiner_deployment_is_ready()
			game_starting_monday_completed = true
	else:
		#push_error("opponent monday finished")
		opponent_monday_received = true
	
	
func confirm_my_deployment():
	#decides which hero's my_target_deployment_lane has to be send over to opponent
	
	confirmed_my_deployment = true
	var increment = 5
	if Lobby.host == true:
		increment = 0
		
	for i in Base.HERO_COUNT:
		i += increment
		var target = Lobby.universal_global_unit_array[i]
		if target.my_target_deployment_lane != 0:
			rpc_id(Lobby.opponent_peer_id,"confirm_deployment_of_hero", i, target.my_target_deployment_lane) 
	
		
	rpc_id(Lobby.opponent_peer_id, "confirm_deployment_status")
	wait_on_opponent_to_confirm_deployment()
	
	
	
@rpc("any_peer", "call_remote", "reliable")
func confirm_deployment_of_hero(key, lane):
	#sets hero's my_target_deployment_lane to the what the opponent decided
	Lobby.universal_global_unit_array[key].my_target_deployment_lane = lane
	
@rpc("any_peer", "call_remote", "reliable")
func confirm_deployment_status():
	#tells oppponent I'm done deploying
	opponent_confirmed_deployment = true
	

	
	
func wait_on_opponent_to_confirm_deployment():
	while  opponent_confirmed_deployment == false:
		await get_tree().create_timer(Base.FAKE_DELTA).timeout

	if Lobby.host == false:
		#joiner waits
		spawn_rect.clear_draggable_heroes()
		#they have to be cleared before deployment is received
		await spawn_rect.wait_for_host_to_rpc_me_deployment()
	the_button_has_been_pressed_frfr()
	#set_process(false)
	
	opponent_confirmed_deployment = false
	confirmed_my_deployment = false
	#if Lobby.host == true:
		#spawn_rect.rpc_joiner_deployment_is_ready()
	#else:
		#await get_tree().create_timer(Base.FAKE_DELTA).timeout

				

			
#######################################################################
###							GLOBALING   							###
#######################################################################


func global_prep_phase():
	push_error("prepphase commence")
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
	
	
	
	
	
	










func round_end():
	player_mana_display.increase_max_mana()
	opponent_mana.increase_max_mana()
	transfer_tower_mana_to_player_mana()
	card_layer.tower_layer.remove_fortifications()
	round_end_signal()
	
	#awaiting sobbingemoji
	
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
	
	round_start()

func round_start():
	scrollh.draw_cards(2)
	
	for i in len(towers):
		towers[i].max_mana.increase_max_mana(1)
		towers[i].current_mana.refill_mana()
		


func transfer_tower_mana_to_player_mana():
	var mana1 = tower_current_mana1.current_mana
	var mana2 = tower_current_mana2.current_mana
	var mana3 = tower_current_mana3.current_mana
	var mana_to_be_added = (mana1 + mana2 + mana3)/3
	#push_error("increasing player mana by (" +str(mana1) + ", "  +str(mana2) + ", " +str(mana3) + ") /3 = " + str(mana_to_be_added))
	player_mana_display.increase_mana(mana_to_be_added)
	
	var mana4 = tower_current_mana1B.current_mana
	var mana5 = tower_current_mana2B.current_mana
	var mana6 = tower_current_mana3B.current_mana
	var mana_to_be_added2 = (mana4 + mana5 + mana6)/3
	#push_error("increasing opponent mana by (" +str(mana4) + ", "  +str(mana5) + ", " +str(mana6) + ") / 3 = " + str(mana_to_be_added2))
	opponent_mana.increase_mana(mana_to_be_added2)
	
func show_opponent_turn_begins():
	opponent_turn_indicator.active_texture_now()
	
	
func show_opponent_turn_is_over():
	opponent_turn_indicator.inactive_texture_now()
	
func enable_me():
	set_disabled(false)
	%Turn_indicator.visible = true
	
	if Lobby.MULTIPLAYER == false:
		Base.gain_singleplayer_action()
	
	#push_error("BUTTON ENABLED")
	
func disable_me():
	if Base.passing == true:
		set_disabled(true)
		%Turn_indicator.visible = false
		
		#push_error("BUTTON DISABLED")
	


#######################################################################
###										   							 ###
#######################################################################

func refresh_player_hp_dmg_to_be_taken():
#	print(towerA.name)
	towerA.visualise_health_loss()
	towerB.visualise_health_loss()

	
func play_global_sfx(type:String, sfx_name:String):
	var file_address = "res://Assets/Sounds/SFX/" +type + "s/" + sfx_name + ".mp3"
	var target_sfx = load(file_address)	
	%Audio_global.stream = target_sfx
	%Audio_global.play()
	
	
	
	
	
	
	
	
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
