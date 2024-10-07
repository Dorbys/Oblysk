extends Control

@onready var waiting_screen = %Waiting_screen

var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 9999
const ADDRESS = "127.0.0.1"

#var opponent_peer_id
##int 1 if joiner, random if hoster
#in Lobby.gd better
var my_peer_id
#needed?

#var player_name:String
##from lineedit
#also in Lobby.gd



func _on_sp_pressed():
	Lobby.MULTIPLAYER = false
	var new_scene_path = "res://Scenes/oblysk.tscn"  # Replace with your scene path
	if Lobby.player_name == "":
		Lobby.player_name = "You"
	get_tree().change_scene_to_file(new_scene_path)


func _on_host_pressed():
	waiting_screen.visible = true
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	#telling game that we are the server
	my_peer_id = 1
	#server's id is always 1
	if Lobby.player_name == "":
		Lobby.player_name = "host"
	
	multiplayer_peer.peer_connected.connect(someone_joined)

func _on_join_pressed():
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	#telling game that we are the client
	my_peer_id = multiplayer.get_unique_id()
	if Lobby.player_name == "":	
		Lobby.player_name = "join"
	
	



func someone_joined(new_peer_id):
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	Lobby.opponent_peer_id = new_peer_id
	if new_peer_id%2 == 0:
		rpc_id(new_peer_id, "gain_starting_initiative")
	else:
		gain_starting_initiative()
	rpc_id(new_peer_id, "start_game")
	start_game()
	#since the rpc travels for a moment, it's better to send it BEFORE 
		#starting the game localy
	

func _on_close_waiting_button_pressed():
	waiting_screen.visible = false
	if multiplayer.is_server():
		multiplayer.clear()  # This stops the server
		multiplayer.multiplayer_peer = null  # Reset the multiplayer peer to default state
		my_peer_id = null
		print("Hosting canceled, server stopped")


	
	
	
@rpc("authority", "call_local", "reliable")
func start_game():
	if Lobby.opponent_peer_id == 0:
		#since I declared it as :int it  now havs different default value
#		push_error("setting joiner's opponent_peer_id to 1")
		Lobby.opponent_peer_id = 1
		Base.swap_player_decks()
	else:
		Lobby.host = true
		
	if $LineEdit.text != "":
		Lobby.player_name = $LineEdit.text
	
#	%Player_HP.rpc_id(Lobby.opponent_peer_id, "set_opponent_name", Lobby.player_name)
#	%Player_HP.set_my_name(Lobby.player_name)
	#moved to spawner
	
	
	
	print("starting the game by " +str(my_peer_id))
	
	var new_scene_path = "res://Scenes/oblysk.tscn"  # Replace with your scene path
	get_tree().change_scene_to_file(new_scene_path)
	
@rpc("any_peer", "call_remote", "reliable")
func gain_starting_initiative():
	Base.INITIATIVE = 1
	
	
	
	
	
	
	
	
	
	
	
	
	
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()



func _on_line_edit_text_changed(new_text):
	Lobby.player_name = new_text
