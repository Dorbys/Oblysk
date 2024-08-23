extends TextureButton

@onready var arena_rect = $"../Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect = $"../Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"

var caller = null
#set it reshow_myself to be the covering that triggered targeting


var which_lane = "alpha"
#alpha or beta 
#arena_rect or abarena_rect

func reshow_myself(to_whom, faction):
	visible = true
	caller = to_whom
	which_lane = faction
	
func hide_myself():
	visible = false
	





func _on_mouse_entered():
	self_modulate.a = 1

func _on_mouse_exited():
	self_modulate.a = 0

func _on_pressed():
	if which_lane == "alpha":
		caller.TList.append(arena_rect)
	elif which_lane == "beta": 
		caller.TList.append(abarena_rect)
	else: push_error("Lane_picker has been given unknown which_lane: " + str(which_lane))
	
