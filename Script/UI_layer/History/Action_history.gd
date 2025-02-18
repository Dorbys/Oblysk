extends Control

@export var played_card_scene: PackedScene

var TYPE = "building"
	#it doesn't but it let's me pass the check whether to send signal here
var animation_time = 0.25
var rotation_time = 0.15


#func _ready():
	#Tower_layer appends me to card_played list


func card_has_been_played(card:Node):
	var card_icon = played_card_scene.instantiate()
	card_icon.card_type = card.TYPE
	card_icon.card_ID = card.Identification
	card_icon.texture = card.Card_pfp
	
	%History.add_child(card_icon)

var shown:bool = false
func _on_show_hide_button_pressed():
	if shown == true:
		shown = false
		hide_history()
	else:
		shown = true
		show_history()
		

func hide_history():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self,
			 "position:x", - %TextureRect.size.x, animation_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%Show_hide_button, "rotation_degrees", 90, rotation_time)

func show_history():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self,
			 "position:x", 0 , animation_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%Show_hide_button, "rotation_degrees", -90, rotation_time)
