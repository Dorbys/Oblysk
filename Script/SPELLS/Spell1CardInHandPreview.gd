extends Control


@export var Card_name = "E"
@export var Card_pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Card_Cost = 1
@export var Card_XP = 2

#var UNIT = 0
#var SPELL = 1
var TYPE = "spell"
var Identification = 3
var Targets = 0

var cross_lane
#for consistency with assign_values()

func _ready():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	if Card_XP == 0:
		%XP.visible = false
	else:
		%XP.visible = true
		%XP.text = str(Card_XP)
	%SPELL_JPEG.texture = Card_pfp
	%Card_description.text = SpellsDB[str(Card_name)+"_description"]
