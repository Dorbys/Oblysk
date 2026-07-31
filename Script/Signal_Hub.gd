extends Control

@onready var lane = $".."
@onready var camera = $"../../Camera2D"
@onready var history = $"../../UI_layer/Action_history"

@onready var tower_a: Control = %TowerA
@onready var tower_b: Control = %TowerB


var card_played_array = []
var unit_targeted_array = []
var lvlup_array = []
var cleanup_phase_array = []
var passive_phase_array = []
var monday_phase_array = []
var tuesday_phase_array = []
var wednesday_phase_array = []
var friday_phase_array = []
var saturday_phase_array = []
var sunday_phase_array = []
var unit_order_changed_array = []



var my_lane = 0

func _ready():
	match lane.name:
		"First_lane":
			my_lane = 1
		"Mid_lane":
			my_lane = 2
		"Last_lane":
			my_lane = 3
		_:
			push_error("ArenaRect appeared on an unkown lane")
			
	tower_a.my_lane = my_lane
	tower_b.my_lane = my_lane
	
	card_played_array.append(history)


func basic_requirements(target):
	var wielder = target.wielder
	if wielder.TYPE == "unit" and wielder.my_lane == my_lane and wielder.alive == true :
		return true
	else:
#		print ("compare these: " +str(my_lane) + str(wielder.TYPE)+str(wielder.my_lane)+str(wielder.alive))
		return false

func before_prep_phase():
	tower_a.before_prep_phase()
	tower_b.before_prep_phase()
	
func remove_fortifications():
	tower_a.remove_fortifications()
	tower_b.remove_fortifications()
	
func card_played_signal(card:Node):
	for i in range(card_played_array.size() - 1, -1, -1):
		#going through array in reverse to prevent issues with shifting indexes
		# the second -1 is condition, the third is step
		var target = card_played_array[i]
		if target != null:
			if target.TYPE == "building" or basic_requirements(target) == true: 
#				await push_error("array position: " + str(i))
				#the problem is int multiple appendations
				await target.card_has_been_played(card)
		else: card_played_array.remove_at(i)

#selects what signal to send based on target type
func something_targeted_signal(target, targeting_entity):
	match target.TYPE:
		"unit":
			unit_targeted_signal(target, targeting_entity)
		"lane":
			push_error("signal not implemented yet")
		"tower":
			push_error("signal not implemented yet")
		_:
			push_error("signal not implemented yet")
	
	
	
	
@rpc("any_peer", "call_remote", "reliable")			
func unit_targeted_signal(unit, targeting_entity):
	#targeting_entity is the function that targeted it
	if unit is int:
		unit = Lobby.universal_global_unit_array[unit]
	#if it was rpced to us, we convert it from int to control	
	if unit.TYPE == "unit":
		for i in range(unit_targeted_array.size() - 1, -1, -1):
			var target = unit_targeted_array[i]
			if target != null:
				if basic_requirements(target): 
					await target.unit_has_been_targeted(unit, targeting_entity)
			else: unit_targeted_array.remove_at(i)
	#if Lobby.MULTIPLAYER == true and multiplayer.get_remote_sender_id() == 0:
		#var unique_unit_key = unit.MY_UNIQUE_UNIT_KEY
		#rpc_id(Lobby.opponent_peer_id,"unit_targeted_signal", unique_unit_key, targeting_entity)
		
func cleanup_phase_signal():
	for i in range(cleanup_phase_array.size() - 1, -1, -1):
		var target = cleanup_phase_array[i]
		if target != null:
			if  basic_requirements(target): 
				await target.cleanup_phase()
			else:
				cleanup_phase_array.remove_at(i)
		else: 
			cleanup_phase_array.remove_at(i)
			print("gonzo cleanup")
		
func passive_phase_signal():
	for i in range(passive_phase_array.size() - 1, -1, -1):
		var target = passive_phase_array[i]
		if target != null:
			if  target.TYPE == "building" or basic_requirements(target): 
				await target.passive_phase()
			else:
				push_error("removing at: " +str(i))
				passive_phase_array.remove_at(i)
		else: 
			passive_phase_array.remove_at(i)
			print("gonzo passive")	
			
func day_x_phase_for_buildings(target_day:String):
	#buildings trig before units
	var current_day_triggers = extract_day_x_triggers_into_array("building", target_day)
	var cdt_size = current_day_triggers.size()
	if  cdt_size == 0:
		return 0
		#if there's noone who trigs today, we return
		
	var cdt_buildings = [] #current_day_triggers_buildings
	for i in cdt_size:
		cdt_buildings.append(current_day_triggers[i].house)
	#now we have all buildings who trig today
		#in the same order as their trigs in current_day_triggers array
	#push_error("cdt_buildings: " +str(cdt_buildings))
	var alpha_squadron = tower_a.extract_children_into_array()
	var beta_squadron = tower_b.extract_children_into_array()
	var alpha_size = alpha_squadron.size()
	var beta_size = beta_squadron.size()
	var squadrons = []
	#push_error("alpha_size: " +str(alpha_size) + " beta_size: " +str(beta_size))
	
	var shorter_array = "beta"
	var greater_size = alpha_size
	if beta_size > alpha_size:
		greater_size = beta_size
		shorter_array = "alpha"
		
	var shorter_array_index: = 0
	#we need to know which of the squadrons is shorter 
		#to not get out of bounds when accessing array
	if Base.initiative == 1:
		squadrons.append(alpha_squadron)
		squadrons.append(beta_squadron)
		if shorter_array == "beta":
			shorter_array_index = 1
	else:
		squadrons.append(beta_squadron)
		squadrons.append(alpha_squadron)
		if shorter_array == "alpha":
			shorter_array_index = 1
	#first of squadrons is of the player with initiative 
		#which determines passive ability order
		
	
		
	for i in greater_size:
		for j in 2:
			if j == shorter_array_index:
				match shorter_array:
					"alpha":
						if i >= alpha_size:
							continue
					"beta":
						if i >= beta_size:
							continue				
			var target = squadrons[j][i]
			var index = cdt_buildings.find(target)
			if index != -1:
				await current_day_triggers[index].call(target_day + "_phase")




			

var day_arrays = { 
	"monday" : monday_phase_array,
	"tuesday" : tuesday_phase_array,
	"wednesday": wednesday_phase_array,
	"friday" : friday_phase_array,
	"saturday" : saturday_phase_array,
	"sunday" : sunday_phase_array
	}	
	

func extract_day_x_triggers_into_array(type:String, target_day:String):
	var result_array = []
	var target_array = day_arrays[target_day]
	for i in range(target_array.size() -1, -1, -1):
						#size() -1 cuz it would iterate once when empty 
		var target = target_array[i]
		if target == null:
			target_array.remove_at(i)
			continue
		match type:
			"unit":
				if "wielder" in target:
				#checks if target has the wielder property
					#only units are wielder, hence trig belongs to unit
					result_array.append(target)
			"building":
				if target is Building_passive_ability:
					result_array.append(target)
				#push_error("result array: " + str(result_array))
			_:
				push_error("unknown trigger type attempted to be extracted")
			
	return result_array
	
	
	
#var day_phases = { 
	#"monday" : monday_phase,
	#"tuesday" : tuesday_phase,
	#"wednesday": wednesday_phase,
	#"friday" : friday_phase,
	#"saturday" : saturday_phase,
	#"sunday" : sunday_phase
	#}	
func day_phase_signal(target_day:String):
	var day_phase_array = day_arrays[target_day]
	
	for i in range(day_phase_array.size() - 1, -1, -1):
		var target = day_phase_array[i]
		if target != null:
			if  target.TYPE == "building" or basic_requirements(target): 
				await target.call(target_day + "_phase")
			else:
				push_error("removing at: " +str(i))
				day_phase_array.remove_at(i)
		else: 
			day_phase_array.remove_at(i)
			print("gonzo monday")	
			
		

#func tuesday_phase_signal():
	#for i in range(tuesday_phase_array.size() - 1, -1, -1):
		#var target = tuesday_phase_array[i]
		#if target != null:
			#if  basic_requirements(target): 
				#await target.tuesday_phase()
		#else: 
			#tuesday_phase_array.remove_at(i)
			#print("gonzo tuesday")	
			#
#func wednesday_phase_signal():
	#for i in range(wednesday_phase_array.size() - 1, -1, -1):
		#var target = wednesday_phase_array[i]
		#if target != null:
			#if  target.TYPE == "building" or basic_requirements(target): 
				#target.wednesday_phase()
		#else: 
			#wednesday_phase_array.remove_at(i)
			#print("gonzo wednesday")	
			#
#
#func friday_phase_signal():
	#for i in range(friday_phase_array.size() - 1, -1, -1):
		#var target = friday_phase_array[i]
		#if target != null:
			#if  target.TYPE == "building" or basic_requirements(target):
				#await target.friday_phase()
		#else: 
			#friday_phase_array.remove_at(i)
			#print("gonzo friday")	

func lvlup_signal(unit):
	for i in range(lvlup_array.size() - 1, -1, -1):
		var target = lvlup_array[i]
		if target != null:
			if basic_requirements(target): 
				await target.unit_lvlups(unit)
		else: lvlup_array.remove_at(i)
		
func unit_order_changed_signal(in_lane):
	for i in range(unit_order_changed_array.size() - 1, -1, -1):
		var target = unit_order_changed_array[i]
		if target != null:
			if in_lane == target.wielder.my_lane:
				await target.unit_order_changed()
		else: unit_order_changed_array.remove_at(i)
	



func _on_click_to_zoom_here_pressed():
	%Click_to_zoom_here.visible = false
	camera.move_camera_to_lane(my_lane)
	
