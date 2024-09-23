extends ColorRect

@export var BUILDING_SCENE: PackedScene

@onready var BUTTON = $"../../THE_BUTTON"
@onready var player_HP = $"../../Player_HP"
@onready var scrollh = $"../../SCROLLH"
@onready var XP_panel = $"../../XP_Panel"

@onready var arena_rect1 = $"../../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect" 
@onready var arena_rect2 = $"../../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect" 
@onready var arena_rect3 = $"../../../Last_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect" 
@onready var beta_arena_rect1 = $"../../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect" 
@onready var beta_arena_rect2 = $"../../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect" 
@onready var beta_arena_rect3 = $"../../../Last_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect" 
var arena_rects

@onready var opp_spawn_rect = $"../Opponent_spawn_rect_fake"
	

var scale_down = 0.8
#how much do we scale down the units

var starting_creep_count = 5

var colliding_units = 0
#to know whether I can make Spawner visible already
#count of how many units still moving to hide their movement

func _ready():
	arena_rects = [arena_rect1, arena_rect2,arena_rect3,
	beta_arena_rect1,beta_arena_rect2,beta_arena_rect3]
	
	if opp_spawn_rect:
		opp_spawn_rect.connect("child_entered_tree",_on_child_entered_tree)

func INITIATE_THE_GAME():
		
	if Lobby.MULTIPLAYER == true:
		player_HP.rpc_id(Lobby.opponent_peer_id, "set_opponent_name", Lobby.player_name)
		
	player_HP.set_my_name(Lobby.player_name)	
		
	deploy_my_heroes()
	#better to keep this clientside since we gonna wait for it from both
	
#	await get_tree().create_timer(Base.FAKE_DELTA).timeout

#	for i in starting_creep_count:
#		spawn_a_creep_in_random_lane_for_both_players(0)
		
	if Lobby.MULTIPLAYER == false:
		for i in starting_creep_count:
			spawn_a_creep_in_random_lane_for_both_players(0)
		
		%BetaFirstLaneDeployRect.create_a_super_creep()
		%BetaMidLaneDeployRect.create_a_super_creep()
		%BetaLastLaneDeployRect.create_a_super_creep()
		#spawns a supercreept in each lane
			
		assign_starting_buildings()
		
		
	elif Lobby.MULTIPLAYER == true:
		for i in starting_creep_count:
			spawn_a_creep_in_random_lane()
		await get_tree().create_timer(0.5).timeout

	else: push_error("incorrect 'Lobby.MULTIPLAYER' value")
	
	await deploy_all()
		
	await get_tree().create_timer(0.2).timeout
	#we were starting before all the creeps spawned lol
	
	BUTTON.global_prep_phase()
	scrollh.draw_cards(8)
	
	BUTTON.card_layer.monday_phase()
		#currently for kimmedi
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	BUTTON.card_layer.tuesday_phase()
	#using BUTTON so that I don't have to count which card layer it is
	#or load the cl1
	
func deploy_my_heroes():
	var target
	
	#SpawnRect should already have 3 heroes prepared there
	var lanes_to_deploy = [%FirstLaneDeployRect,
	%MidLaneDeployRect,%LastLaneDeployRect]
	var ints_for_lanes = [0,1,2]
	
	ints_for_lanes.shuffle()
	#ok so basically it shuffles
	for i in 3:
		target = get_child(2-i) 
		target.reparent(lanes_to_deploy[ints_for_lanes[i]])
		#I'm not decreasing their scale since this won't be visible
		rpc_id(Lobby.opponent_peer_id,"deploy_opponent_heroes", ints_for_lanes[i])
		
@rpc("any_peer", "call_remote", "reliable")
func deploy_opponent_heroes(which_lane):
	var target
	#SpawnRect should already have 3 heroes prepared there
	var lanes_to_deploy = [%BetaFirstLaneDeployRect,
	%BetaMidLaneDeployRect,%BetaLastLaneDeployRect]

	target = opp_spawn_rect.get_child(opp_spawn_rect.get_child_count()-1) 
	target.reparent(lanes_to_deploy[which_lane])

func collide_units(skip_target = -1):
	#currently copied from SpawnRect, skip_target could be removed
	var collide_time = 0.2
	var target
	var destinationX
	var offset = (0.5 * Base.CARD_WIDTH) 
	var center = (size.x)/2
	

	
			
	var population = get_child_count()
	var mid = ceil(population/2)
	
	for i in population:
		if i == skip_target:
			continue
		
			
		target = get_child(i)
		
		if skip_target != -1 and i> skip_target:
			i -= 1
			#modifies the placement of following cards, but still targets the right
			#child since the "skipped one" is still present
			
		if population%2 == 0:
			destinationX = center - offset + ((i+1-mid) * Base.CARD_WIDTH)

		else:
			destinationX =  center + ((i-mid) * Base.CARD_WIDTH)

		var tween = create_tween().set_parallel(true)
		await tween.tween_property(target,"position",
		 Vector2(destinationX,0),
		 collide_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	if colliding_units > 0 : 
		colliding_units -= 1
	#because we don't care about when units are removed	

func _on_child_entered_tree(node):
	colliding_units += 1
	node.enter_draggable_state()
	node.pre_deploy_respawn()
	collide_units()
	


func new_wave_of_creeps():
	%FirstLaneDeployRect.create_a_creep()
	%MidLaneDeployRect.create_a_creep()
	%LastLaneDeployRect.create_a_creep()
	%BetaFirstLaneDeployRect.create_a_creep()
	%BetaMidLaneDeployRect.create_a_creep()
	%BetaLastLaneDeployRect.create_a_creep()
		
	if Lobby.MULTIPLAYER == true:
		spawn_a_creep_in_random_lane()
	else:
		spawn_a_creep_in_random_lane_for_both_players(1)
	
func spawn_a_creep_in_random_lane():
	#Can only be called if MULTIPLAYER
	var uno = randi()%3

	match uno:
		0:
			%FirstLaneDeployRect.create_a_creep()
		1:
			%MidLaneDeployRect.create_a_creep()
		2:
			%LastLaneDeployRect.create_a_creep()
	rpc_id(Lobby.opponent_peer_id, "opponent_spawned_random_creep_in_this_lane", uno)
	#we tell opponent where to create random creep
#	push_error("calling to " +str(Lobby.opponent_peer_id) + " with info " + str(uno))
		
@rpc("any_peer", "call_remote", "reliable")
func opponent_spawned_random_creep_in_this_lane(which_lane:int):
#	push_error("received call from " +str(Lobby.opponent_peer_id) + " with info " + str(which_lane))

	match which_lane:
		0:
			%BetaFirstLaneDeployRect.create_a_creep()
		1:
			%BetaMidLaneDeployRect.create_a_creep()
		2:
			%BetaLastLaneDeployRect.create_a_creep()
		_:
			push_error("incorrect 'client_spawned_random_creep_in_this_lane' input")
	
			
func spawn_a_creep_in_random_lane_for_both_players(include_supers = 1):
	var uno = randi()%3
	match uno:
		0:
			%FirstLaneDeployRect.create_a_creep()
		1:
			%MidLaneDeployRect.create_a_creep()
		2:
			%LastLaneDeployRect.create_a_creep()
			
	uno = randi()%3
	match uno:
		0:
			%BetaFirstLaneDeployRect.create_a_creep()
		1:
			%BetaMidLaneDeployRect.create_a_creep()
		2:
			%BetaLastLaneDeployRect.create_a_creep()
			
	if include_supers == 1:
		uno = randi()%3
		match uno:
			0:
				%BetaFirstLaneDeployRect.create_a_super_creep()
			1:
				%BetaMidLaneDeployRect.create_a_super_creep()
			2:
				%BetaLastLaneDeployRect.create_a_super_creep()
	

func deploy_all():
	var deploy_function = "deploy_unit"
	if Lobby.MULTIPLAYER == true:
		deploy_function = "deploy_unit_MP"
		
	var alpha_squadron = []
	var beta_squadron = []
	var alpha_lanes = [%FirstLaneDeployRect, %MidLaneDeployRect, %LastLaneDeployRect ]
	var beta_lanes = [%BetaFirstLaneDeployRect, %BetaMidLaneDeployRect, %BetaLastLaneDeployRect ]
	#I want to alternate between deploying from alphalane and from betalane
	#and add "voids" which would represent skipping a deploy
	#no void is generated, it just skips
	
	for i in 3:
		var alpha_deployer = alpha_lanes[i]
		var beta_deployer = beta_lanes[i]
		alpha_squadron = []
		beta_squadron = []
		#make sure they empty
		for j in alpha_deployer.get_child_count():
			alpha_squadron.append(alpha_deployer.get_child(j))
		for j in beta_deployer.get_child_count():
			beta_squadron.append(beta_deployer.get_child(j))
		#now we have two arrays which containg the nodes that have to be deployed		
		var length_difference =  len(alpha_squadron) - len(beta_squadron)
		#one might contain more that the other
		if length_difference > 0:
			for j in length_difference:
				beta_squadron.append(null)
		if length_difference < 0:
			for j in abs(length_difference):
				alpha_squadron.append(null)
		#This makes the arrays equally long by adding nulls to them
		alpha_squadron.shuffle()
		beta_squadron.shuffle()
		#poggers this exists
		var starting_squadron = alpha_squadron
		var second_squadron = beta_squadron
		var starting_deployer = alpha_deployer
		var second_deployer = beta_deployer
		var start_int = randi()
		if start_int%2 == 0:
			starting_squadron = beta_squadron
			second_squadron = alpha_squadron
			starting_deployer = beta_deployer
			second_deployer = alpha_deployer
		# 50% chance that beta starts deploying
		var deploy_target
		for k in 2*len(starting_squadron):
			if k%2 == 0:
				deploy_target = starting_squadron[k/2]
				if deploy_target != null:
					await starting_deployer.call(deploy_function,deploy_target)
			if k%2 == 1:
				deploy_target = second_squadron[floor(k/2)]
				if deploy_target != null:
					await second_deployer.call(deploy_function,deploy_target)
		#deploys the units switching between starting and second deployer
		# skipping when its null
				
#	for i in len(arena_rects):
#		arena_rects[i].reset_curving()
			
			
#func deploy_all_MP():
#	#This function is only resolved for host, the results are rpced to joiner
#	var alpha_squadron = []
#	var alpha_lanes = [%FirstLaneDeployRect, %MidLaneDeployRect, %LastLaneDeployRect ]
#
#	#I want to alternate between deploying from alphalane and from betalane
#	#and add "voids" which would represent skipping a deploy
#	#no void is generated, it just skips rn
#
#	for i in 3:
#		var alpha_deployer = alpha_lanes[i]
#		alpha_squadron = []
#		#make sure they empty
#		for j in alpha_deployer.get_child_count():
#			alpha_squadron.append(alpha_deployer.get_child(j))
#		alpha_squadron.shuffle()
#
#		var deploy_target
#		for k in len(alpha_squadron):
#			deploy_target = alpha_squadron[k]
#			if deploy_target != null:
#				await alpha_deployer.deploy_unit(deploy_target)

					
func _on_child_order_changed():
	if get_child_count() > 0:
		Base.lock_pass_button()
	else:
		Base.unlock_pass_button(true)
		#have to set forced as true because 'if' triggers more times than 'else'



func assign_starting_buildings():
	var beta_towers = [BUTTON.towerB1.buildings, BUTTON.towerB2.buildings, BUTTON.towerB3.buildings]
	
	for i in range(1,4):
		var house = BUILDING_SCENE.instantiate()
		house.Build_name = BuildDB.BUILD_DB[i][BuildDB.NAMEPOSITION]
		house.Build_Pfp = Base.BUILDINGS_SMALLS_TEXTURES[i]
		house.is_aura = BuildDB.BUILD_DB[i][BuildDB.ISAURAPOSITION]
		house.affects = BuildDB.BUILD_DB[i][BuildDB.AFFPOSITION]
		house.position.x = 50+ beta_towers[i-1].get_child_count() * 110
		#For now placement
		beta_towers[i-1].add_child(house)
		
		
func more_enemies():
	pass
