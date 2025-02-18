extends Control

@onready var player_mana = $PLAYER_MANA
#var oppponent_mana_display#: Node

var current_mana = 1
#we start on 1 player mana
var max_mana = 3
#not connected to towers, if starting mana is changed, this must too


func _ready():
	update_my_text()
#	if name == "Player_mana_display":
#		oppponent_mana_display = $"../Opponent_info/Opponent_mana"
#	push_error("my name is: " +name )


		
	
func increase_max_mana():
	max_mana += 1
	#used at the end of round
	
func spend_mana(amount):
#	push_error("spending mana: " + str(amount))
	current_mana -= amount
	update_my_text()
#	if name == "Player_mana_display":
#		#cuz other is renamed to "Opponent...."
#		rpc_id(Lobby.opponent_peer_id, "mirror_my_mana_change", amount)

func increase_mana(amount):
	current_mana += amount
	if current_mana > max_mana:
		current_mana = max_mana
	update_my_text()
	
	
func update_my_text():
	player_mana.text = str(current_mana)
	

#@rpc("any_peer", "call_remote", "reliable")
#func mirror_my_mana_change(amount):
#	#using same scene
#	if multiplayer.get_remote_sender_id() == 0:
#		push_error("LOCAL " + "change mirrored to: " +name)
#	else: 
#		push_error("change mirrored to: " +name)
#	oppponent_mana_display.call("spend_mana", amount)
#
