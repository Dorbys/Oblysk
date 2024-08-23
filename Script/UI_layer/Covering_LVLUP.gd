extends Control

#also spawns as child of UI layer

@onready var XP_panel = $"../XP_Panel"

@onready var Card_layer1 = $"../../First_lane/Card_layer"
@onready var arena_rect1 = $"../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect1 = $"../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"

@onready var Card_layer2 = $"../../Mid_lane/Card_layer"
@onready var arena_rect2 = $"../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect2 = $"../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"

@onready var Card_layer3 = $"../../Last_lane/Card_layer"
@onready var arena_rect3 = $"../../Last_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect3 = $"../../Last_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"

var Card_layer 
var arena_rect 
var abarena_rect




var XP 

func _ready():
	new_lane()
	update_XP()
	Base.lock_pass_button()
	
func new_lane():
	match Base.current_lane:
		1:
			Card_layer = Card_layer1
			arena_rect = arena_rect1
			abarena_rect = abarena_rect1
		2:
			Card_layer = Card_layer2
			arena_rect = arena_rect2
			abarena_rect = abarena_rect2
		3:
			Card_layer = Card_layer3
			arena_rect = arena_rect3
			abarena_rect = abarena_rect3
	
func update_XP():
	XP = XP_panel.XP
	Card_layer.lets_lvlup(XP,self)
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		delete_myself()





		
		


func delete_myself():
	Card_layer.lets_stop_targeting()
#	for i in arena_rect.get_child_count():
#		var target = arena_rect.get_child(i)
#		if target.TYPE == 0:
#			target.reshow_ability()
#			target.clean_myself_from_effects()
#		var target2 = abarena_rect.get_child(i)
#		if target2.TYPE == 0:
#			target2.reshow_ability()
#			target2.clean_myself_from_effects()
#	arena_rect.TargetingSpell = 0
#	abarena_rect.TargetingSpell = 0
	Base.unlock_pass_button()
	self.queue_free()
