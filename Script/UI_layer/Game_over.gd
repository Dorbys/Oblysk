extends Control
@onready var you_win = $YOU_WIN
@onready var you_lose = $YOU_LOSE
@onready var audio_stream_player = $"../../AudioStreamPlayer"
@onready var w_player = $W_player
@onready var l_player = $L_player


var anima_duration:float = 1.2
var over:bool = false

func YOU_WIN():
	if Lobby.MULTIPLAYER == true:
		%Wyou.text = Lobby.player_name
		%Wbob.text = Lobby.opponent_name
	print("YOU WIN")
	audio_stream_player.stop()
	w_player.play()
	visible = true
	you_win.visible = true
	over = true
	var tween = create_tween()
	tween.tween_property(self,"modulate:a",1,anima_duration)
	
func YOU_LOSE():
	%Lbob.text = Lobby.opponent_name
	%Lyou.text = Lobby.player_name
	print("YOU LOSE")
	audio_stream_player.stop()
	l_player.play()
	visible = true
	you_lose.visible = true
	over = true
	var tween = create_tween()
	tween.tween_property(self,"modulate:a",1,anima_duration)

func game_over_check():
	return over
