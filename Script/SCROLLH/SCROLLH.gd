extends ScrollContainer

@onready var hand_rect = %HandRect





func _on_draw_1_pressed():
	draw_cards(8)
		
func draw_cards(amount):
	for i in amount:
		%HandRect.drawing()
	#so that it's easier to call from outside


func move_to_next_lane():
	for i in hand_rect.get_child_count():
		hand_rect.get_child(i).new_lane()
