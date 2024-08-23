extends Control


@export var Card_name = "E"
@export var Build_Pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Card_Cost = 1
@export var Card_XP = 2

func _ready():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	%XP.text = str(Card_XP)
	%CARD_JPEG.texture = Build_Pfp
	
	%Card_description.text = BuildDB[str(Card_name)+"_description"]
