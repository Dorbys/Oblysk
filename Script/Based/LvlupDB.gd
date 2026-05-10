extends Node


var NAMEPOSITION = 0
var COSTPOSITION = 1
#var XPPOSITION = 2
var TARGPOSITION = 2
var TYPEPOSITION = 3
var BONUSTARGPOSITION = 4
var CROSSLANEPOSITION = 5
var ISPLAYEDONPOSITION = 6



#TYPE 1 for spells and 11 for lvlup spell, also 0 for units and 10 for lvlup units
	#outdated and converted to strings

var LVLUPS_DB = [
["Fresh_on", 3, Enums.Targeting.one_ally,11,Enums.Targeting.none,false, "Unit"],
["Duplicate",1,Enums.Targeting.lane,11,Enums.Targeting.none, false, "Lane"], 
["Legion",8,Enums.Targeting.lane,11,Enums.Targeting.none,false, "Lane"],
["Railgun", 2,Enums.Targeting.one_unit,11,Enums.Targeting.none,true, "Unit"],
["Exreality", 5,Enums.Targeting.lane,11,Enums.Targeting.none, false, "Lane"],
["Extreality", 88,Enums.Targeting.lane,11,Enums.Targeting.none, false, "Lane"],
["Extreality", 88,Enums.Targeting.lane,11,Enums.Targeting.none, false, "Lane"],
["Extreality", 88,Enums.Targeting.lane,11,Enums.Targeting.none, false, "Lane"],
["Extreality", 88,Enums.Targeting.lane,11,Enums.Targeting.none, false, "Lane"]]
# Called when the node enters the scene tree for the first time.

func Fresh_on(Target, _current_player = "", _rpced = false):
	var diff = Target.HealthM - Target.HealthC
	await Target.increase_HealthC(2)
	
	if _rpced == false:
		if diff >= 2:
			Target.MYrena_rect.scrollh.draw_cards(1)
	
func Duplicate(lane, _current_player = "", _rpced = false):
	if _rpced == false:
		var ITEM_ID = 1
		
		
		var handa = lane.scrollh.hand_rect
		var item = handa.create_item(ITEM_ID)
		handa.add_child(item)
		await handa.collide_cards()
	
func Legion(allied_row, _current_player = "", _rpced = false):
	var target_lanes = [allied_row.BUTTON.arena_rect1, allied_row.BUTTON.arena_rect2,
	allied_row.BUTTON.arena_rect3]
	if Base.current_lane < 4:
		target_lanes.remove_at(Base.current_lane -1)
		
	if _rpced == false:
		var Legionare_index = 2
		for i in 2:
			await target_lanes[i].spawn_unit(Legionare_index, 2, null, false, false)
			#target_lanes[i].mass_second_ready()
	
var railgun_host_owner:int 	
var railgun_join_owner:int
#Unique key of heroes with the ability
var opponent_railgun_damage = 3
var Railgun_damage = 3
func Railgun(target, _current_player = "", _rpced = false):
	if Lobby.MULTIPLAYER == false or _current_player == Lobby.player:
		#If I cast this, use my damage
		target.take_damage(Railgun_damage)
	else:
		#else use opponents damage and increase it
		target.take_damage(opponent_railgun_damage)
		opponent_railgun_damage +=1
		
	if Lobby.MULTIPLAYER == false or _current_player == Lobby.player:
		Railgun_damage += 1
		Railgun_description = str("Deal " +str(Railgun_damage) + " magical damage to a unit in any lane,
increase cost and damage of future railguns by 1")
		var rg_owner = railgun_host_owner
		if _current_player == "join":
			rg_owner = railgun_join_owner

		push_error("rg_owner value here: " +str(rg_owner) +  "host: " 
		+str(railgun_host_owner) + " join: " +str(railgun_join_owner))
		var connection_to_p = Lobby.universal_global_unit_array[rg_owner].Ability1.get_child(2)
		await connection_to_p.new_snipe_damage(Railgun_damage)
	

func Exreality(lane, _current_player = "", _rpced = false):
	var opp_buildings 
	if lane.MY_identity == "A":
		opp_buildings = lane.OPTower.buildings
	elif lane.MY_identity == "B":
		opp_buildings = lane.MYTower.buildings
	#so that it doesn't matter which lane I target, might have to create
		#factionless selection instead
	if _rpced == true:
		match lane.MY_identity:
			"A":
				opp_buildings = lane.MYTower.buildings
			"B": 
				opp_buildings = lane.OPTower.buildings
			_:
				push_error("unknowns MY_identity value: " +str(lane.MY_identity))
		
	var population = opp_buildings.get_child_count()
	if population > 0:
		var gamba = randi()%population
		opp_buildings.get_child(gamba).destroy_myself()
		
		
var Fresh_on_description = "Heal 2 Health to an allied unit, 
if at least 2 health was healed, draw a card"
var Duplicate_description = "Creates a historical weapon"
var Legion_description = "Summon two legionaires to both other lanes"
var Railgun_description = str("Deal " +str(Railgun_damage) + " magical damage to a unit in any lane,
increase cost and damage of future railguns by 1")
var Exreality_description = "Destroy a random enemy building"
