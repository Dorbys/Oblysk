extends TextureRect



@onready var my_tower = $"../.."
@onready var UI_layer = $"../../../../../UI_layer"


var my_lane
var opp_lane

var is_aura = true
var affects = "allies"

var affects_faction_alpha = false
var affects_faction_beta = false

#var Identification = 1
var Build_name 
var Build_Pfp
#var auratype = "lane"

var aura_unique_id

var text_for_tooltip = "tooltip didn't load properly"

func _ready():
#	print("My tower is: " + str(my_tower.name))
	texture = Build_Pfp
	aura_unique_id = Base.aura_unique_id
	Base.increase_aura_unique_id()
	
	if is_aura == true:
		var affectionload = load("res://Script/AurasFromBuildingsAffections/" +str(Build_name) +"Affection.gd")
		%Affection.set_script(affectionload)
		%Affection.aura_unique_id = aura_unique_id
		%Affection.Build_name = Build_name
		text_for_tooltip = %Affection.text_for_tooltip
	else: 
		var Passive_ability_node = Control.new()
		var passiveload = load("res://Script/PassiveBuildingsList/" +str(Build_name) +".gd")
		Passive_ability_node.set_script(passiveload)
		Passive_ability_node.visible = false
		add_child(Passive_ability_node)
		
	if my_tower.name == "TowerA":
		my_lane = $"../../../../Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
		opp_lane = $"../../../../Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
		
		if affects == "allies":
			affects_faction_alpha = true
		elif affects == "enemies":
			affects_faction_beta = true
		elif affects == "both":
			affects_faction_alpha = true
			affects_faction_beta = true
		#determines which lane this aura influences
		#just "enemies" effect for now
		
			
	elif my_tower.name == "TowerB":
		my_lane = $"../../../../Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
		opp_lane = $"../../../../Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
		
		if affects == "allies":
			affects_faction_beta = true
		elif affects == "enemies":
			affects_faction_alpha = true
		elif affects == "both":
			affects_faction_alpha = true
			affects_faction_beta = true
		#determines which lane this aura influences
		#just 1 effect for now
		
	#connect what's my and the opposite lane
	
	
	
	
	
	if is_aura == true:
		#Following part affects all desired units by the aura because it was played
		var population = my_lane.get_child_count()
		#we stil believe there will be the same amount of nodes in each arena all the time
		var target
		var wielder
		if affects == "allies":
			for i in population:
				wielder = (my_lane.get_child(i))
				if wielder.TYPE == 0:
					target	= wielder.lane_auras
					#to attach the aura into auras slot not on hero itself
					affect_unit(target,wielder)
					
		elif affects == "enemies":
			for i in population:
				wielder = (opp_lane.get_child(i))
				if wielder.TYPE == 0:
					target	= wielder.lane_auras
					affect_unit(target,wielder)
					
		elif affects == "both":
			for i in population:
				wielder = (my_lane.get_child(i))
				if wielder.TYPE == 0:
					target	= wielder.lane_auras
					affect_unit(target,wielder)
				
				wielder = (opp_lane.get_child(i))
				if wielder.TYPE == 0:
					target	= wielder.lane_auras
					affect_unit(target,wielder)

func affect_unit(target, wielder):
#	print("AFFECTING")
	if %Affection.do_I_affect_this(wielder) == true:
		var node_name = str(Build_name) + "_" + str(aura_unique_id)
		if target.has_node(node_name):
			target.get_node(node_name).CHECKED = true
			#if its already affected by me, no reason to affect it again
		else:
			var aura_effect = Control.new()
			var aurascript = load("res://Script/AurasFromBuildingsList/" +str(Build_name) +".gd")
			aura_effect.set_script(aurascript)
			aura_effect.name = str(Build_name) +"_" + str(aura_unique_id)
			target.add_child(aura_effect)
#			push_error("adding aura to: " +str(target.name) + str(target.get_child_count()))
			#target is the slot for laneaura effects
	
	
func  do_I_affect_faction(faction):
	if faction == "alpha":
		return affects_faction_alpha
	elif faction == "beta":
		return affects_faction_beta
		
	else: 
		print("An aura is affecting both factions")
		return true
		
	#NEED A SOLUTION FOR "BOTH"
	#this might work
	
func destroy_myself():
	#There is no checking for stopping affecting units, demo only for opp and timed
	var destr_time = 0.5
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 0, destr_time)
	await get_tree().create_timer(destr_time).timeout 
#	card_layer.lane_aura_check_both()
	#trying to call this via on_child_Exited from buildings of tower
	self.queue_free()
	
	
		
	
	
	
