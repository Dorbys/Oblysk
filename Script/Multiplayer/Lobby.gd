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


var unique_unit_key = 9
#first 10 reserved for heroes, increases before adoptation
var universal_global_unit_array = [null, null, null, null, null, null, null, null, null, null]

