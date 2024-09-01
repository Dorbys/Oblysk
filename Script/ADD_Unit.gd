extends TextureButton
@onready var option_button = $"../OptionButton"

@onready var arena_rect1 = $"../../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect1 = $"../../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var card_layer1 = $"../../../First_lane/Card_layer"

@onready var arena_rect2 = $"../../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect2 = $"../../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var card_layer2 = $"../../../Mid_lane/Card_layer"

@onready var arena_rect3 = $"../../../Last_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect3 = $"../../../Last_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var card_layer3 = $"../../../Last_lane/Card_layer"

@onready var game_over = $"../../Game_over"

var arena_rect
var abarena_rect
var card_layer

func _ready():
	new_lane()
	
func new_lane():
	match Base.current_lane:
		1:
			arena_rect = arena_rect1
			abarena_rect = abarena_rect1
			card_layer = card_layer1
		2:
			arena_rect = arena_rect2
			abarena_rect = abarena_rect2
			card_layer = card_layer2
		3:
			arena_rect = arena_rect3
			abarena_rect = abarena_rect3
			card_layer = card_layer3

func _on_pressed():
	#print(get_index())
	#ArenaRect.Remove_Unit(option_button.get_selected_id())
	if option_button.get_selected_id() == 0:
		arena_rect.Cheating_Units(randi() % 3, false)
		abarena_rect.Cheating_Units(randi() % 3, false)
	elif option_button.get_selected_id() == 1:
		for i in arena_rect.get_child_count():
			arena_rect.get_child(i).queue_free()
		for i in abarena_rect.get_child_count():
			abarena_rect.get_child(i).queue_free()
	elif option_button.get_selected_id() == 2:
		card_layer.curve_rng_both()
	elif option_button.get_selected_id() == 3:
		%Player_HP.decrease_alpha_players_HP(5)
	elif option_button.get_selected_id() == 4:
		%Player_HP.decrease_beta_players_HP(5)

