extends Control

@onready var card_layer = $"../../../Card_layer"

@export var BUILDING_SCENE: PackedScene

func refresh_aura(target,faction,wielder):
	var population = get_child_count()
	for i in population:
		var house = get_child(i)
		
		if house.is_aura == true and house.do_I_affect_faction(faction) == true:
			await house.affect_unit(target,wielder)
		await get_tree().create_timer(Base.MICRO_TIME).timeout

#		else: print(house.is_aura)
#		print(house.do_I_affect_faction(faction))


func _on_child_exiting_tree(_node):
	card_layer.lane_aura_check_both()
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	collide_buildings()
	
var building_tower_distance = 75
var building_spacing = 110
func collide_buildings():
	var collide_time = 0.4
	var population = get_child_count()
	var tween = create_tween().set_parallel(true)
	#push_error("colliding")
	for i in range(population-1 , -1, -1):
#		get_child(i).position.x = 50 + (i * 110)
		tween.tween_property(get_child(i),"position:x",building_tower_distance + (i * building_spacing), collide_time)

	
func make_building(ID):
	var house = BUILDING_SCENE.instantiate()
	house.Build_name = BuildDB.BUILD_DB[ID][BuildDB.NAMEPOSITION]
	house.Build_Pfp = Base.BUILDINGS_SMALLS_TEXTURES[ID]
#		house.Card_Cost = BuildDB.BUILD_DB[ID][BuildDB.COSTPOSITION]
#		house.Build_XP = BuildDB.BUILD_DB[ID][BuildDB.XPPOSITION]
	house.is_aura = BuildDB.BUILD_DB[ID][BuildDB.ISAURAPOSITION]
	house.affects = BuildDB.BUILD_DB[ID][BuildDB.AFFPOSITION]
#		house.Identification = ID
	house.position.x = building_tower_distance + (get_child_count() * building_spacing)
	
	#For now placement
	add_child(house)
	#push_error("house added, child count: " + str(get_child_count()))
	collide_buildings()
	
	
	
	
	
	
	
	
	
	
