extends Label


var max_mana = 3000

func _ready():
	
	update_my_text()

func increase_max_mana(how_much):
	max_mana += how_much
	update_my_text()
	
func update_my_text():
	text = str(max_mana)
