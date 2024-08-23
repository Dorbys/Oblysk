extends TextureRect


func show_or_hide():
	if visible == false:
		visible = true
	else:
		visible = false

func _on_button_pressed():
	visible = false


func _on_help_pressed():
	visible = true
