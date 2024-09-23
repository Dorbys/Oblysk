extends ColorRect

@export var UNIT_SCENE: PackedScene

@onready var arena_rect1 = $"../../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect" 
@onready var arena_rect2 = $"../../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect" 
@onready var arena_rect3 = $"../../../Last_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect" 
@onready var beta_arena_rect1 = $"../../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect" 
@onready var beta_arena_rect2 = $"../../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect" 
@onready var beta_arena_rect3 = $"../../../Last_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect" 
var my_lane

var scale_down = 0.58
#how much do we scale down the units
var overlap_modifier = 0.4
#if we are over capacity, how much of the card that is beaing placed over
#should remain visible
var capacity = 5

var movement_time = 0.25

var Y_OFFSET = 400
# because we cant place units from top anymore

var faction = "Alpha"

func _ready():
	match name:
		#my own name determines what lane I'm placed at
		"FirstLaneDeployRect":
			my_lane = arena_rect1
		"MidLaneDeployRect":
			my_lane = arena_rect2
		"LastLaneDeployRect":
			my_lane = arena_rect3
		"BetaFirstLaneDeployRect":
			my_lane = beta_arena_rect1
			faction = "Beta"
		"BetaMidLaneDeployRect":
			my_lane = beta_arena_rect2
			faction = "Beta"
		"BetaLastLaneDeployRect":
			my_lane = beta_arena_rect3
			faction = "Beta"
			



func create_a_creep():
	var ID = 0
	#for now
#	var population = get_child_count()
	var another = UNIT_SCENE.instantiate()
	var DB_slot = CreepsDB.SPECIAL_DB[ID]
	
	if faction == "Alpha":
		another.Unit_Pfp = Base.SPECIAL_TEXTURES[0]
	elif faction == "Beta":
		another.Unit_Pfp = Base.SPECIAL_TEXTURES[1]
	else: push_error("spawnrect doesnt belong to any know faction")
	
	another.Unit_Attack = DB_slot[CreepsDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[CreepsDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[CreepsDB.ARMORPOSITION]
	another.Card_XP = DB_slot[CreepsDB.XPPOSITION]
	
	
#	another.position.x=  population * (Base.CARD_WIDTH * scale_down)		
	another.Identification = ID
#	another.scale =Vector2(scale_down,scale_down)
		
	add_child(another)
	
	
	collide_units(-1,0)

var last_ID = 4
func create_a_super_creep():
	
	var another = UNIT_SCENE.instantiate()
	if last_ID == 3:
		last_ID = 4
	elif last_ID == 4:
		last_ID = 3
		
	var DB_slot = CreepsDB.CREEPS_DB[last_ID]
	another.Unit_Name = CreepsDB.CREEPS_DB[last_ID][CreepsDB.NAMEPOSITION]
	another.Unit_Pfp = Base.CREEP_TEXTURES[last_ID]
	
	another.Unit_Attack = DB_slot[CreepsDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[CreepsDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[CreepsDB.ARMORPOSITION]
	another.Card_XP = 0
	
	another.Unit_Ability_texture = Base.CREEP_ABILITY_TEXTURES[last_ID]
	another.Unit_Ability_cooldown = AbilitiesDB.CREEP_ABILITIES_DB[last_ID][AbilitiesDB.COOLDOWNPOSITION]
	another.has_ability = true
	
	add_child(another)
	
	
	collide_units(-1,0)
	
func collide_units(skip_target = -1, pretty = 1):
	var destination_X = 0
	var destination_Y = 0
	var population = get_child_count()
	var target 
	var tween
	if pretty == 1:
		tween = get_tree().create_tween().set_parallel(true)
		tween.pause()
	for i in population:
		if i == skip_target:
			continue
		
			
		target = get_child(i)
		
		if skip_target != -1 and i> skip_target:
			i -= 1
			#modifies the placement of following cards, but still targets the right
			#child since the "skipped one" is still present
			
#		get_child(i).position.x = (0.5 * Base.CARD_WIDTH) + (i * Base.CARD_WIDTH * scale_down)
		if i+1>capacity: #theres +1 cuz i begins at 0 and I want to keep capacity clear
#			get_child(i).position.x = (0.5 * Base.CARD_WIDTH) + ((i-capacity) * Base.CARD_WIDTH * scale_down)
#			get_child(i).position.y = Base.CARD_HEIGHT*scale_down
			destination_X = (0.5 * Base.CARD_WIDTH * scale_down) + ((i-capacity) * Base.CARD_WIDTH * scale_down)
			destination_Y = Base.CARD_HEIGHT*scale_down*overlap_modifier + Y_OFFSET
		else: 
			destination_X = (0.5 * Base.CARD_WIDTH * scale_down) + (i * Base.CARD_WIDTH * scale_down)
			destination_Y = 0 + Y_OFFSET
#			get_child(i).position.y = 0
		if pretty == 1:
			
			
			tween.tween_property(target,"position:x",destination_X,movement_time)
			tween.tween_property(target,"position:y",destination_Y,movement_time)
#			tween.tween_property(target,"scale",Vector2(scale_down,scale_down),movement_time)
			
		else:
			target.position.x = destination_X
			target.position.y = destination_Y 
			target.scale = Vector2(scale_down,scale_down)
			
	if pretty == 1:
		Base.lock_pass_button()
		tween.play()
		await get_tree().create_timer(movement_time).timeout
		Base.unlock_pass_button()

#	print("this LaneDeployRect has " + str(get_child_count()) + " children")

func _can_drop_data(_at_position, data):
	#data these: HeroNode , parent
	if data[0].HERO == true:
		return true
		
func _drop_data(_at_position, data):
	if data[1] != self:
		var target = data[0]
		var destination_X = 0
		var destination_Y = 0
		var population = get_child_count()
		if population >= capacity:
			
			destination_X = (0.5 * Base.CARD_WIDTH * scale_down ) + ((population-capacity) * Base.CARD_WIDTH * scale_down)
			destination_Y = (Base.CARD_HEIGHT * scale_down * overlap_modifier) + Y_OFFSET
		else: 
			destination_X = (0.5 * Base.CARD_WIDTH * scale_down) + (population * Base.CARD_WIDTH * scale_down)
			destination_Y = 0 + Y_OFFSET
	#			get_child(i).position.y = 0
		destination_X += global_position.x
		destination_Y += global_position.y 
		
		
		Base.lock_pass_button()
		#gotta be careful with tweeners since they can persist even after unit leaves
		var tween = create_tween().set_parallel(true)
		tween.tween_property(target,"global_position:x",destination_X,movement_time)
		tween.tween_property(target,"global_position:y",destination_Y,movement_time)
		tween.tween_property(target,"scale",Vector2(scale_down,scale_down),movement_time)
		
		#movement is done twice because moving the hero from one nodes position to enother 
		#has to be done outside collide()
		#CAN CHECK ?????????????????????????????????????
		

		data[1].collide_units(target.get_index())
		#we add index there so that collide can happen before this tween finishes
		#and it skips the card that is moving out
		
		await get_tree().create_timer(movement_time).timeout 
		Base.unlock_pass_button()
		
		data[1].remove_child(target)

		target.scale = Vector2(scale_down,scale_down)
		add_child(target)
			
		collide_units()
	
	
#func deploy_my_units():
	#Isn't used at the moment, keeping for a while


#	var population = get_child_count()
#	var squadron = []
#	for i in population:
#		squadron.append(get_child(i))
#	squadron.shuffle() 
#	#for random order of deployment 
#
#	for i in population:
#		var target = squadron[population-1-i]
#		if target.Unit_Name != "AlphaCreep":
#			target.appear_alive()
#			target.leave_draggable_state()
#			my_lane.attempt_to_land(target,self)
#
#
#			#since Alphacreeps aren't units but UnitCIHPreviews 
#			#we have to do this workaround yea 
#		else:
#			my_lane.spawn_lane_creep()
#			target.queue_free()
#		await get_tree().create_timer(Base.FAKE_DELTA).timeout 

			
func deploy_unit(target):
	if target.HERO == true:
		target.appear_alive()
		target.leave_draggable_state()
		my_lane.respawn_here(target)
		
		
		#since Alphacreeps aren't units but UnitCIHPreviews 
		#we have to do this workaround yea 
	elif target.Unit_Name == "AlphaCreep":
		my_lane.spawn_lane_creep()
		target.queue_free()
	
	elif target.Unit_Name == "Skelegone":
		my_lane.spawn_unit(3)
		target.queue_free()
	else:
		#sommelier
		my_lane.spawn_unit(4)
		target.queue_free()
	await get_tree().create_timer(Base.FAKE_DELTA).timeout		
		
func deploy_unit_MP(target):
	#only in multiplayer
	if target.HERO == true:
		target.appear_alive()
		target.leave_draggable_state()
		if Lobby.opponent_peer_id != 1:
			my_lane.respawn_here(target)
		
		
		
	elif target.Unit_Name == "AlphaCreep":
		if Lobby.opponent_peer_id != 1:
			my_lane.spawn_lane_creep()
		target.queue_free()
	#since Alphacreeps aren't units but UnitCIHPreviews 
		#we have to do this workaround yea 
		
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	
