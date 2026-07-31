extends Card_preview



	

func local_ready():
	TYPE = "building"


func _on_tree_exited():
	if previewed_card:
		previewed_card.visible = true
	card_layer.card_preview_is_no_longer_being_dragged()
	arena.move_roof_back()
	abarena.move_roof_back()
	#moving roof back automatically sets TargetingSpell to 0
	Base.unlock_pass_button()
	#because we locked it once we started dragging the preview
	the_button.global_lets_reshow_abilities_and_items()
	
	
