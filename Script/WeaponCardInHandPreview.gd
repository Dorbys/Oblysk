extends Control



@export var Item_Name = "E"
@export var Item_Pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Item_Stat = 1
@export var Item_Cost = 2
var Item_cooldown

#var UNIT = 0
#var SPELL = 1
var TYPE = 2
var ITEMM = 0
var Identification = 3


func _ready():
	%NAME.text = Item_Name
	%COST.text = str(Item_Cost)
	%WEAPON_JPEG.texture = Item_Pfp
	
	%STATS.text = ItemsDB[str(Item_Name)+"_description"]

	
	
