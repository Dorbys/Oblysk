extends Control


class_name Card_preview

#Ok and now it spawn under Oblysk
#Well and I just moved it under UI_layer
#Under oblysk again
#Now under SCROLLH

@onready var the_button = $"../../THE_BUTTON"

@onready var arena_rect1 = $"../../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect1 = $"../../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var arena1 = $"../../../First_lane/Card_layer/SCROLLA/Arena"
@onready var abarena1 = $"../../../First_lane/Card_layer/SCROLLB/Abarena"
@onready var card_layer1 = $"../../../First_lane/Card_layer"

@onready var arena_rect2 = $"../../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect2 = $"../../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var arena2 = $"../../../Mid_lane/Card_layer/SCROLLA/Arena"
@onready var abarena2 = $"../../../Mid_lane/Card_layer/SCROLLB/Abarena"
@onready var card_layer2 = $"../../../Mid_lane/Card_layer"

@onready var arena_rect3 = $"../../../Last_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect3 = $"../../../Last_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var arena3 = $"../../../Last_lane/Card_layer/SCROLLA/Arena"
@onready var abarena3 = $"../../../Last_lane/Card_layer/SCROLLB/Abarena"
@onready var card_layer3 = $"../../../Last_lane/Card_layer"


@onready var name_label: Label = %Name_label
@onready var cost_label: Label = %Cost_label
@onready var art_rect: TextureRect = %Art_rect
@onready var xp_label: Label = %XP_label
@onready var description_label: Label = %Description_label

var TYPE
var card_name:String
var card_cost:int
var card_art
var card_xp:int = 0
var card_DB
	#ItemsDB / SpellsDB ...

var Identification:int = 3

##appears as a child of this scene's root node i guess
##it does when all it has above it is control nodes i believe, c-layers somehow stop it
var arena_rect:Node
var abarena_rect:Node
var arena:Node
var abarena:Node 
var card_layer:Node


#the card that was dragged
var previewed_card:Node#:

	
func _ready() -> void:
	
		#to prevent hover previews in hand
	local_ready() #assigns TYPE
	if previewed_card:
		previewed_card.visible = false
	name_label.text = card_name
	cost_label.text = str(card_cost)
	art_rect.texture = card_art
	if card_xp == 0:
		xp_label.visible = false
	else:
		xp_label.visible = true
		xp_label.text = str(card_xp)
	if TYPE != "unit":
		description_label.text = card_DB[str(card_name)+"_description"]
	
	new_lane()
	
	card_layer.card_preview_is_being_dragged()

func local_ready():
	#children of class can overwrite this if needed, eg spell targets
	pass	
	
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
