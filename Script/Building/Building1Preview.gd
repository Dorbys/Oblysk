extends Card_preview


@export var Card_name = "E"
@export var Build_Pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Card_Cost = 1
@export var Card_XP = 2

#var UNIT = 0
#var SPELL = 1
var TYPE = 1
var Identification = 3

func _ready():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	%XP.text = str(Card_XP)
	%CARD_JPEG.texture = Build_Pfp
	
	%Card_description.text = BuildDB[str(Card_name)+"_description"]
	
	new_lane()
	
func new_lane():
	match Base.current_lane:
		1:
			arena = arena1
			abarena = abarena1
			arena_rect = arena_rect1
			abarena_rect = abarena_rect1
			card_layer = card_layer1
		2:
			arena = arena2
			abarena = abarena2
			arena_rect = arena_rect2
			abarena_rect = abarena_rect2
			card_layer = card_layer2

		3:
			arena = arena3
			abarena = abarena3
			arena_rect = arena_rect3
			abarena_rect = abarena_rect3
			card_layer = card_layer3


func _on_tree_exited():
	arena.move_roof_back()
	abarena.move_roof_back()
	#moving roof back automatically sets TargetingSpell to 0
	Base.unlock_pass_button()
	#because we locked it once we started dragging the preview
	the_button.global_lets_reshow_abilities_and_items()
	
	
