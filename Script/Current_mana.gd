extends Label

@onready var tower = $"../.."

var current_mana

func _ready():
	if Base.PLAYTEST == 1:
		%Max_mana.max_mana = 3
	current_mana = %Max_mana.max_mana
	#so that mana begins on the same as max mana
	update_my_text()
	
func spend_mana(amount):
	current_mana -= amount
	if current_mana <0:
		tower.player_mana.spend_mana(abs(current_mana))
		current_mana = 0
	update_my_text()

func refill_mana():
	var max_mana_this_turn = %Max_mana.max_mana
	current_mana += max_mana_this_turn
	if current_mana > max_mana_this_turn:
		current_mana = max_mana_this_turn
	update_my_text()
	
func update_my_text():
	text = str(current_mana)
