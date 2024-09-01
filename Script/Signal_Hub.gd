extends Control

@onready var lane = $".."
@onready var camera = $"../../Camera2D"


var card_played_list 
var unit_targeted_list = []
var lvlup_list = []
var cleanup_phase_list = []
var monday_phase_list = []
var tuesday_phase_list = []
var wednesday_phase_list = []
var friday_phase_list = []
var unit_order_changed_array = []

var VIP_list = []
#wtf

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
			
	%TowerA.my_lane = my_lane
	%TowerB.my_lane = my_lane


func basic_requirements(target):
	var wielder = target.wielder
	if wielder.TYPE == 0 and wielder.my_lane == my_lane and wielder.alive == 1 :
		return true
	else:
#		print ("compare these: " +str(my_lane) + str(wielder.TYPE)+str(wielder.my_lane)+str(wielder.alive))
		return false

func card_played_signal(card):
	for i in range(card_played_list.size() - 1, -1, -1):
		#going through list in reverse to prevent issues with shifting indexes
		# the second -1 is condition, the third is step
		var target = card_played_list[i]
		if target != null:
			if basic_requirements(target) == true: 
				await target.card_has_been_played(card)
		else: card_played_list.remove_at(i)
		
func unit_targeted_signal(unit, targeting_entity):
	#targeting_entity is the function that targeted it
	if unit.TYPE == 0:
		for i in range(unit_targeted_list.size() - 1, -1, -1):
			var target = unit_targeted_list[i]
			if target != null:
				if basic_requirements(target): 
					await target.unit_has_been_targeted(unit, targeting_entity)
			else: unit_targeted_list.remove_at(i)
		
func cleanup_phase_signal():
	for i in range(cleanup_phase_list.size() - 1, -1, -1):
		var target = cleanup_phase_list[i]
		if target != null:
			if  basic_requirements(target): 
				await target.cleanup_phase()
		else: 
			cleanup_phase_list.remove_at(i)
			print("gonzo cleanup")
		
func monday_phase_signal():
	for i in range(monday_phase_list.size() - 1, -1, -1):
		var target = monday_phase_list[i]
		if target != null:
			if  target in VIP_list or basic_requirements(target): 
				await target.monday_phase()
		else: 
			monday_phase_list.remove_at(i)
			print("gonzo monday")	
			
		

func tuesday_phase_signal():
	for i in range(tuesday_phase_list.size() - 1, -1, -1):
		var target = tuesday_phase_list[i]
		if target != null:
			if  basic_requirements(target): 
				await target.tuesday_phase()
		else: 
			tuesday_phase_list.remove_at(i)
			print("gonzo tuesday")	
			
func wednesday_phase_signal():
	for i in range(wednesday_phase_list.size() - 1, -1, -1):
		var target = wednesday_phase_list[i]
		if target != null:
			if  target in VIP_list or basic_requirements(target): 
				target.wednesday_phase()
		else: 
			wednesday_phase_list.remove_at(i)
			print("gonzo wednesday")	
			

func friday_phase_signal():
	for i in range(friday_phase_list.size() - 1, -1, -1):
		var target = friday_phase_list[i]
		if target != null:
			if  target in VIP_list or basic_requirements(target):
				await target.friday_phase()
		else: 
			friday_phase_list.remove_at(i)
			print("gonzo friday")	

func lvlup_signal(unit):
	for i in range(lvlup_list.size() - 1, -1, -1):
		var target = lvlup_list[i]
		if target != null:
			if basic_requirements(target): 
				await target.unit_lvlups(unit)
		else: lvlup_list.remove_at(i)
		
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
	
