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
	get_tree().change_scene_to_file(new_scene_path)


func _on_host_pressed():
	waiting_screen.visible = true
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	#telling game that we are the server
	my_peer_id = 1
	#server's id is always 1
	
	multiplayer_peer.peer_connected.connect(someone_joined)

func _on_join_pressed():
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	#telling game that we are the client
	my_peer_id = multiplayer.get_unique_id()
	
	



func someone_joined(new_peer_id):
	await get_tree().create_timer(1).timeout
	start_game()
	Lobby.opponent_peer_id = new_peer_id
	rpc_id(new_peer_id, "start_game")
	

func _on_close_waiting_button_pressed():
	waiting_screen.visible = false
	if multiplayer.is_server():
		multiplayer.clear()  # This stops the server
		multiplayer.multiplayer_peer = null  # Reset the multiplayer peer to default state
		my_peer_id = null
		print("Hosting canceled, server stopped")


	
	
	
@rpc("authority", "call_local", "reliable")
func start_game():
	if Lobby.opponent_peer_id == null:
		Lobby.opponent_peer_id = 1
		
	if $LineEdit.text == null:
		Lobby.player_name = my_peer_id
	else:
		Lobby.player_name = $LineEdit.text
	
#	%Player_HP.rpc_id(Lobby.opponent_peer_id, "set_opponent_name", Lobby.player_name)
#	%Player_HP.set_my_name(Lobby.player_name)
	#moved to spawner
	
	
	
	print("starting the game by " +str(my_peer_id))
	
	var new_scene_path = "res://Scenes/oblysk.tscn"  # Replace with your scene path
	get_tree().change_scene_to_file(new_scene_path)
	

	





func _on_line_edit_text_changed(new_text):
	Lobby.player_name = new_text
