extends ScrollContainer

@onready var hand_rect = %HandRect
@onready var opponent_scrollh = $"../Opponent_info/Opponent_SCROLLH"





func _on_draw_1_pressed():
	draw_cards(1)
		
func draw_cards(amount):
	if Lobby.MULTIPLAYER == true:
		rpc_id(Lobby.opponent_peer_id, "visualize_drawing_cards_for_opponent", amount)
	for i in amount:
		%HandRect.drawing()
	#so that it's easier to call from outside


func move_to_next_lane():
	for i in hand_rect.get_child_count():
		hand_rect.get_child(i).new_lane()
		
@rpc("any_peer", "call_remote", "reliable")
func visualize_drawing_cards_for_opponent(amount):
	opponent_scrollh.draw_cards(amount)
