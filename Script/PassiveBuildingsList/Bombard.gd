extends Node

@onready var BUTTON = $"../../../../../../UI_layer/THE_BUTTON"


func _ready():
	get_parent().text_for_tooltip = "Round end: Deal " +str(DAMAGE) + " physical damage to a random enemy in a random lane"	
	BUTTON.round_end_signal_list.append(self)
	
var DAMAGE = 50

func round_end():
	
	var randolane
	var lane1_presence = BUTTON.arena_rect1.is_there_a_unit_check()
	var lane2_presence = BUTTON.arena_rect2.is_there_a_unit_check()
	var lane3_presence = BUTTON.arena_rect3.is_there_a_unit_check()
	var targetable_lanes = []
	if lane1_presence == true:
		targetable_lanes.append(BUTTON.arena_rect1)
	if lane2_presence == true:
		targetable_lanes.append(BUTTON.arena_rect2)
	if lane3_presence == true:
		targetable_lanes.append(BUTTON.arena_rect3)
	var length = len(targetable_lanes)
	if  length > 0:
		var gamba = randi()%length
		
		randolane = targetable_lanes[gamba]
		
		if Base.PLAYTEST == 1:
			shoot_at_random(randolane)
	
	else: 
		print("no units in lane, cant bombard")
	

	
	
func shoot_at_random(lane):
	print("BOMBARDING")
	var targs = []
	var population = lane.get_child_count()
	for i in population:
		var mb_target = lane.get_child(i)
		if mb_target.TYPE == 0:
			targs.append(mb_target)
	var length = len(targs)
	if length>0:
		var gamba = randi()%length
		var target = targs[gamba]
		var expected_damage = DAMAGE - target.ArmorC
		if expected_damage > 0:
			target.take_damage(expected_damage)
