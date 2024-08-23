extends Control

@onready var player_mana = $PLAYER_MANA

var current_mana = 1
#we start on 1 player mana
var max_mana = 3
#not connected to towers, if starting mana is changed, this must too


func _ready():
	update_my_text()
	
func increase_max_mana():
	max_mana += 1
	#used at the end of round
	
func spend_mana(amount):
	current_mana -= amount
	update_my_text()

func increase_mana(amount):
	current_mana += amount
	if current_mana > max_mana:
		current_mana = max_mana
	update_my_text()
	
func update_my_text():
	player_mana.text = str(current_mana)
	
	
	
