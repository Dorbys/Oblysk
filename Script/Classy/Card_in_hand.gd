extends Control


class_name Card_In_Hand

@onready var UI_layer = $"../../../../.."
#UI layer is here for nomana purposes
@onready var the_button = $"../../../../../THE_BUTTON"
#for globaling

@onready var player_mana = $"../../../../../Player_mana_display"

@onready var card_layer1 = $"../../../../../../First_lane/Card_layer"
@onready var arena1 = $"../../../../../../First_lane/Card_layer/SCROLLA/Arena"
@onready var abarena1 = $"../../../../../../First_lane/Card_layer/SCROLLB/Abarena"
@onready var arena_rect1 = $"../../../../../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect1 = $"../../../../../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var tower_mana1 = $"../../../../../../First_lane/Tower_layer/TowerA/Mana_display/Current_mana"

@onready var card_layer2 = $"../../../../../../Mid_lane/Card_layer"
@onready var arena2 = $"../../../../../../Mid_lane/Card_layer/SCROLLA/Arena"
@onready var abarena2 = $"../../../../../../Mid_lane/Card_layer/SCROLLB/Abarena"
@onready var arena_rect2 = $"../../../../../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect2 = $"../../../../../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var tower_mana2 = $"../../../../../../Mid_lane/Tower_layer/TowerA/Mana_display/Current_mana"

@onready var card_layer3 = $"../../../../../../Last_lane/Card_layer"
@onready var arena3 = $"../../../../../../Last_lane/Card_layer/SCROLLA/Arena"
@onready var abarena3 = $"../../../../../../Last_lane/Card_layer/SCROLLB/Abarena"
@onready var arena_rect3 = $"../../../../../../Last_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect3 = $"../../../../../../Last_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var tower_mana3 = $"../../../../../../Last_lane/Tower_layer/TowerA/Mana_display/Current_mana"

var card_layer
var arena 
var abarena 
var arena_rect 
var abarena_rect 
var tower_mana

var cross_lane = false
#this default can be changed, hopefully in each 

func _ready():
	new_lane()
	
func new_lane():
	match Base.current_lane:
		1:
			card_layer = card_layer1
			arena = arena1
			abarena = abarena1
			arena_rect = arena_rect1
			abarena_rect = abarena_rect1
			tower_mana = tower_mana1
		2:
			card_layer = card_layer2
			arena = arena2
			abarena = abarena2
			arena_rect = arena_rect2
			abarena_rect = abarena_rect2
			tower_mana = tower_mana2
		3:
			card_layer = card_layer3
			arena = arena3
			abarena = abarena3
			arena_rect = arena_rect3
			abarena_rect = abarena_rect3
			tower_mana = tower_mana3
	



var BIG_SCALE = Vector2(1.2,1.2)
#var NORM_SCALE = Vector2(1.0,1.0)
var UP_THE_YMIDSCREEN = -300

var FANT = 0.15 	#FOCUS_ANIMATION_TIME

var no_mana_warning = load("res://Scenes/UI/No_mana_warning.tscn")
var no_caster_warning = load("res://Scenes/UI/No_caster_warning.tscn")




func create_card_in_hand_preview(source,ID):

	if source.showing == 0 and Base.show_CIH_preview == true:
	#so that its not made multiple times
#		if arena_rect.TargetingSpell == 0 and arena_rect.EquippingItem == 0:
		var preview = source.PreviewScene.instantiate()
		source.assign_stats(preview,ID)
		source.add_child(preview)
		focus_on_me(preview)
		source.showing = 1

func remove_card_in_hand_preview(source):
	if source.showing == 1:
		source.get_child(1).queue_free()
		await get_tree().create_timer(Base.FAKE_DELTA).timeout 
		source.showing = 0



func focus_on_me(target):
	grow_big(target)
	go_up(target)

func grow_big(target):
	var tween = target.get_tree().create_tween()
	tween.tween_property(target,
	"scale", BIG_SCALE,FANT).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func go_up(target):
	target.z_index = 10
	#is rendered above nodes with lower z index

	var tween = target.get_tree().create_tween()
	tween.tween_property(target,"position:y",
	 UP_THE_YMIDSCREEN,FANT).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)







func does_player_have_enough_mana(caller):
	if caller.tower_mana.current_mana + player_mana.current_mana >= caller.Card_Cost:
		return true
	else:
		return false
		
func not_enough_mana(caller):
	var mana_jumpscare = no_mana_warning.instantiate()
	caller.UI_layer.add_child(mana_jumpscare)
	
func no_hero_to_cast_this(caller):
	var caster_jumpscare = no_caster_warning.instantiate()
	caller.UI_layer.add_child(caster_jumpscare)
