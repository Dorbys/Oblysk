extends Control


@export var Card_name = "E"
@export var Card_pfp = load("res://Assets/Textures/Missing_texture.png")
@export var Card_Cost = 1
@export var Card_XP = 2

func _ready():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	if Card_XP == 0:
		%XP.visible = false
	else:
		%XP.visible = true
		%XP.text = str(Card_XP)
	%CARD_JPEG.texture = Card_pfp
	
	%Card_description.text = BuildDB[str(Card_name)+"_description"]
