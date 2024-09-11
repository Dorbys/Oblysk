extends Control
@onready var arena_dsc = %Arena_dshowcase
@onready var abarena_dsc = %Abarena_dshowcase
@onready var spawner = $"../Spawner/SpawnRect"
@onready var opponent_spawner = $"../Spawner/Opponent_spawn_rect_fake"


@onready var arena_rect1 = $"../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect" 
@onready var abarena_rect1 = $"../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect" 
@onready var card_layer1 = $"../../First_lane/Card_layer"
@onready var towerB = $"../../First_lane/Tower_layer/TowerB"
@onready var towerA = $"../../First_lane/Tower_layer/TowerA"

@onready var arena_rect2 = $"../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect" 
@onready var abarena_rect2 = $"../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect" 
#@onready var card_layer2 = $"../../Mid_lane/Card_layer"

@onready var arena_rect3 = $"../../Last_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect" 
@onready var abarena_rect3 = $"../../Last_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect" 
#@onready var card_layer3 = $"../../Last_lane/Card_layer"
#gonna respawn everything in first lane until deployment is implemented



func _ready():
	await initiate_heroes(Base.HeroDeck,arena_rect1,towerB)
	
	if Lobby.MULTIPLAYER == true:
		await get_tree().create_timer(0.1).timeout
		await initiate_heroes(Base.OpponentHeroDeck,abarena_rect1,towerA)
	
	await get_tree().create_timer(0.1).timeout
	#guess I need to wait a moment?
		#not all nodes probly have time to spawn
	spawner.INITIATE_THE_GAME()
		

var herocount = 5
func initiate_heroes(deck, arena_rect, tower):
	for i in herocount:
		#crates the five heroes from players hero deck
		arena_rect.create_hero(deck[i%herocount])
		
#	arena_rect.collide_units()
	#not needed?
	
	for i in 3:
		#3 of them will be randomly deployed to a lane
		var target = arena_rect.get_child(i)
		#has to be 0 else it will take the third and fifth basly
		#has to be i actually cuz I'm replacing them with voids as we go
		arena_rect.transfer_hero_to_spawner(target)
		#doing it like this so that I deal with voids over there as well

	
	
		
	Add_grave(arena_rect.get_child(3), arena_rect)
	arena_rect.insert_void(0,1,1)
	if arena_rect == arena_rect1:
		await update_arena_dsc()
	else:
		await update_abarena_dsc()
	#moves the HERO4 to a grave and decreases their turns to spawn by 1
#	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	#needed or else both heroes would be there for 1 turn
		#not needed when await is in the update_arena part
	
	#HERE FOR AGROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO DEPLOY
	#11111111111111111111111111111111111111111111111111111111111111111111111111
	
	Add_grave(arena_rect.get_child(4), arena_rect)
	arena_rect.insert_void(0,1,1)
	#takes the last hero out and places a void, so that they can be cleared now	
	
	
	#################################3
	if arena_rect == abarena_rect1:
		await update_abarena_dsc()
	#for testing of fakespawner opponent
	###################################3
	
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	#waiting for the last hero to complete
	await card_layer1.clear_up_both()
	#remove the remaining voids
	tower.damage_to_be_taken = 0
	tower.increase_damage_to_be_taken(0)
	#because it was increased by creation of heroes

	
func Add_grave(node, parent):
	if parent == arena_rect1 or parent == arena_rect2 or parent == arena_rect3:
		for i in 5:
			var target = arena_dsc.get_child(i)
			if target.r_time == 0:
#				await get_tree().create_timer(card_layer.death_anim_length).timeout
#				parent.remove_child(node)
#				parent.insert_void(index,1,1)
#				target.add_child(node)
				node.visible = false
				node.alive = 0
				#twice cuz initiating the game doesnt actually kill them
				#and wanna have sure opposer stays fine
				node.reparent(target)
				
				target.texture = node.Unit_Icon
				#getting texture has to be before making it invisible
#				node.visible= false
				target.r_time = 3
#				if Base.Combat_phase == 0:
				target.r_update()
				
				break
				
	if parent == abarena_rect1 or parent == abarena_rect2 or parent == abarena_rect3:
		for i in 5:
			var target = abarena_dsc.get_child(i)
#			print(target.r_time)
			if target.r_time == 0:
#				await get_tree().create_timer(card_layer.death_anim_length).timeout
#				parent.remove_child(node)
#				target.add_child(node)
				node.visible = false
				node.alive = 0
				#twice cuz initiating the game doesnt actually kill them
				#and wanna have sure opposer stays fine
				node.reparent(target)
				target.texture = node.Unit_Icon
#				node.visible= false
				target.r_time = 3
				if Base.Combat_phase == 0:
					target.r_update()
				break
		
func respawn(grave, hero):
	var parent = grave.get_parent()
	if parent == arena_dsc:
#		grave.remove_child(hero)
#		spawner.add_child(hero)
		hero.visible = true
		#the hero actually remains somewhere on the screen and I cant move it 
		#X nor Y
		#despite being 'mod.a = 0' I still need to make it invisible 
		# for mouse to ignore it
		hero.rotation = 0
		hero.modulate.a = 1
		hero.reparent(spawner)
		#units are automatically collided upon entering spawner
#		spawner.collide_units()

	elif parent == abarena_dsc:
		
		hero.visible = true
		hero.rotation = 0
		hero.modulate.a = 1
		hero.position = Vector2(0,0)
		hero.reparent(opponent_spawner)
		#units are automatically collided upon entering spawner

		
		
func respawn2(grave, hero):
#											copy this one as landing kinda
	#where tf is this used
	push_error("respawn2 used here")
	
	var parent = grave.get_parent()
	if parent == arena_dsc:
		var population = arena_rect1.get_child_count()
		var empty_slots = []
		for i in population:
			if arena_rect1.get_child(i).SITT == 1:
				empty_slots.append(i)

		var landing = 0
		if len(empty_slots) != 0:
			randomize()  # Initialize the random number generator
			var random_index = randi() % empty_slots.size()
			landing = empty_slots[random_index]
#			print("random index is: " + str(random_index))
			var replacing_void = arena_rect1.get_child(empty_slots[random_index])
#			var new_x = replacing_void.position.x
			replacing_void.queue_free()
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
		else:
			var random_index = randf()
			if random_index <  0.5:
				landing = population
			abarena_rect1.insert_void(landing, 1, 1)
#		hero.visible = true
		grave.remove_child(hero)
		hero.visible = true

		arena_rect1.add_child(hero)
#		print("AHERO IS " +str(hero))
		arena_rect1.move_child(hero, landing)
		hero.respawn()
		arena_rect1.collide_units()
#		hero.position.x = new_x
#		for i in (population-landing):
#			arena_rect.move_child(arena_rect.get_child(population-(i+1)),population-i)
#		arena_rect.collide_units()


	elif parent == abarena_dsc:
		var population = abarena_rect1.get_child_count()
		var empty_slots = []
		for i in population:
			if abarena_rect1.get_child(i).SITT == 1:
				empty_slots.append(i)

		var landing = 0
		if len(empty_slots) != 0:
			randomize()  # Initialize the random number generator
			var random_index = randi() % empty_slots.size()
			landing = empty_slots[random_index]
#			print("random index is: " + str(random_index))
			var replacing_void = abarena_rect1.get_child(empty_slots[random_index])
#			var new_x = replacing_void.position.x
			replacing_void.queue_free()
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
		else:
			randomize()  # Initialize the random number generator
			var random_index = randf()
			if random_index <  0.5:
				landing = population
			arena_rect1.insert_void(landing, 1, 1)
#		print("ABAHERO IS " +str(hero))
#		hero.visible = true
		grave.remove_child(hero)
		hero.visible = true
		abarena_rect1.add_child(hero)
		abarena_rect1.move_child(hero, landing)
		hero.respawn()
		abarena_rect1.collide_units()
#		hero.position.x = new_x
#		for i in (population-landing):
#			abarena_rect.move_child(abarena_rect.get_child(population-(i+1)),population-i)
#			abarena_rect.collide_units()
	else:
		push_error ("unknown parent of a grave")
		
		

func update_both():
	var targets = [arena_dsc,abarena_dsc]
	for i in 2:
		for j in 5:
			await targets[i].get_child(j).r_update()
#			await get_tree().create_timer(Base.FAKE_GAMMA).timeout
			#should be better with real respawn




func update_arena_dsc():
	var targets = arena_dsc
	for j in 5:
		targets.get_child(j).r_update()
		await get_tree().create_timer(Base.FAKE_GAMMA).timeout
			
func update_abarena_dsc():
	var targets = abarena_dsc
	for j in 5:
		targets.get_child(j).r_update()
		await get_tree().create_timer(Base.FAKE_GAMMA).timeout
		
#these two are mainly for beginning of the game to not intercept
