extends Control

@onready var player_mana = $PLAYER_MANA
var oppponent_mana_display



var current_mana = 1
#we start on 1 player mana
var max_mana = 3
#not connected to towers, if starting mana is changed, this must too


func _ready():
	update_my_text(false)
	#if name == "Player_mana_display":
		#oppponent_mana_display = $"../Opponent_info/Opponent_mana"
	#push_error("my name is: " +name )
	#if oppponent_mana_display == null: push_error("still null")


		
	
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
	
	
func update_my_text(send_to_opponent = true):
	player_mana.text = str(current_mana)
	#if Lobby.MULTIPLAYER == true and send_to_opponent == true:
		#push_error("sending rpc to mirror mana change")
		#rpc_id(Lobby.opponent_peer_id,"mirror_my_mana_change", current_mana)
#
#@rpc("any_peer", "call_remote", "reliable")
#func mirror_my_mana_change(amount):
	##always rpced ig
	#if oppponent_mana_display == null:
		#push_error("opponent_mana_display is null here")
	#else:
		#oppponent_mana_display.set_mana(amount)
	
#func set_mana(amount):
	##used when rpcing change 
	#current_mana = amount
	#update_my_text(false)
