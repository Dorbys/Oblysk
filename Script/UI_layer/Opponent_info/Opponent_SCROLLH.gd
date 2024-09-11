extends ScrollContainer


@onready var hand_rect = %HandRect
@onready var opponent_info = $".."


func _ready():
	if Lobby.MULTIPLAYER == false:
		opponent_info.visible = false


#func _on_draw_1_pressed():
#	draw_cards(1)
		
func draw_cards(amount):
	for i in amount:
		%HandRect.drawing()
	#so that it's easier to call from outside


func move_to_next_lane():
	for i in hand_rect.get_child_count():
		hand_rect.get_child(i).new_lane()
