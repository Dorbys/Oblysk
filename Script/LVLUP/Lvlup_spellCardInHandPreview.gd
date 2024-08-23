extends Control


@export var Card_name = "E"
@export var Card_Pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Card_Cost = 1
@export var Card_XP = 2

#var UNIT = 0
#var SPELL = 1
var TYPE = 1
var Identification = 3
var Targets = 0

var cross_lane

func _ready():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	%XP.text = str(Card_XP)
	%SPELL_JPEG.texture = Card_Pfp
	%Card_description.text = LvlupDB[str(Card_name)+"_description"]

