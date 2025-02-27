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

var hp_modifier:String = "-"
	# "-" for reducing, "+" for increasing


func _ready():
	Base.debugging = true
	if hp_modifier == "-":
		Base.minus_HPing = true
	elif hp_modifier == "+" :
		Base.plus_HPing = true	
	new_lane()
	Card_layer.lets_target_a_unit(self)
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
	
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		delete_myself()


func delete_myself():
	Card_layer.lets_stop_targeting()

	Base.debugging = false
	if hp_modifier == "-":
		Base.minus_HPing = false
	elif hp_modifier == "+":
		Base.plus_HPing = false

	Base.unlock_pass_button()
	self.queue_free()
