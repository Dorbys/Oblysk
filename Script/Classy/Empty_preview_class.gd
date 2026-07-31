extends Node

class_name empty_preview

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



var previewed_card:Node
	#not needed, but not to add ifs to assign_stats of CIHs



func _ready() -> void:	
	local_ready() #assigns TYPE
	
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
	
	

func local_ready():
	#children of class overwrite this  
	pass	
