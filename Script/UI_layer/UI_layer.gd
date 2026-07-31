extends CanvasLayer

@export var no_action_warning: PackedScene
@export var no_caster_warning: PackedScene
@export var no_mana_warning: PackedScene

@onready var the_button: TextureButton = %THE_BUTTON


###################################################################
######################## PLAYABILITY CHECKS #######################
###################################################################

func does_player_have_action():
	if Base.granted_action == 1 and the_button.disabled == false:
								#gotta check the button or imma
		return true
	elif Base.passing == false: 
		return true
	else:
		you_dont_have_action()
		return false


func you_dont_have_action():
	var action_jumpscare = no_action_warning.instantiate()
	add_child(action_jumpscare)
		
func not_enough_mana():
	var mana_jumpscare = no_mana_warning.instantiate()
	add_child(mana_jumpscare)
	
func no_hero_to_cast_this():
	var caster_jumpscare = no_caster_warning.instantiate()
	add_child(caster_jumpscare)
