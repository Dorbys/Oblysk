extends Panel

@onready var UI_layer = $".."

@export var covering : PackedScene

@onready var h_0 = $Hover/VBoxContainer/HBoxContainer/H0
@onready var h_1 = $Hover/VBoxContainer/HBoxContainer/H1
@onready var h_2 = $Hover/VBoxContainer/HBoxContainer2/H2
@onready var h_3 = $Hover/VBoxContainer/HBoxContainer2/H3
@onready var h_4 = $Hover/VBoxContainer/HBoxContainer3/H4

@onready var h_0xp = $Hover/VBoxContainer/HBoxContainer/H0XP
@onready var h_1xp = $Hover/VBoxContainer/HBoxContainer/H1XP
@onready var h_2xp = $Hover/VBoxContainer/HBoxContainer2/H2XP
@onready var h_3xp = $Hover/VBoxContainer/HBoxContainer2/H3XP
@onready var h_4xp = $Hover/VBoxContainer/HBoxContainer3/H4XP


var hero_pfp_labels_in_deck_order 
var hero_xp_labels_in_deck_order 



var XP = 1000
func increase_xp(amount):
	XP += amount
	
	%XP_Count.text = str(XP)
	


#var HeroDeck = [0,4,2,3,1]
#ACAMAR 	PLOTT 		KAJUS		KIMMEDI 	DORBYS
func _ready():
	%XP_Count.text = str(XP)
	hero_pfp_labels_in_deck_order = [h_0,h_1,h_2,h_3,h_4]
	hero_xp_labels_in_deck_order = [h_0xp,h_1xp,h_2xp,h_3xp,h_4xp]
	update_xp_labels()
	update_pfps()
	

func update_xp_labels():
	for i in 5:
		hero_xp_labels_in_deck_order[i].text = str(Base.Player_heroes[i].Lvlup_xp)

func update_pfps():
		for i in 5:
			hero_pfp_labels_in_deck_order[i].texture = Base.Player_heroes[i].Unit_Icon

func _on_mouse_entered():
	%Hover.visible = true
	
func _on_mouse_exited():
	%Hover.visible = false


func _on_button_pressed():
#	var loaded_covering = load("res://Scenes/Covering_LVLUP.tscn")
	var another = covering.instantiate()
	#MUST USE ":" when exporting packed scenes
	UI_layer.add_child(another)
	#starts the lvlup selection
	
	
	
	



