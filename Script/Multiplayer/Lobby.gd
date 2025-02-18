extends Node

#this is for transfering Multiplayer information between scenes and such


var MULTIPLAYER = true
#to build mp funcs and change the view of scenes based on whether mp ornah

#var INITIATIVE = 0
#moved to Base.gd cuz it operates THEBUTTON

var opponent_peer_id:int
#int 1 if joiner, random if hoster

var player_name:String
#from lineedit

var host: bool = false
var player: String 
#eitger "host" or "join" based on who I am
var current_player: String
#either "host" or "join" based on whose turn it is

var unique_unit_key = 9
#first 10 reserved for heroes, increases before adoptation
var universal_global_unit_array = [null, null, null, null, null, null, null, null, null, null]



func update_current_player():
	if host == true:
		if Base.granted_action == 1:
			current_player = "host"
		else:
			current_player = "join"
	else:
		if Base.granted_action == 1:
			current_player = "join"
		else:
			current_player = "host" 
