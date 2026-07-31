extends Card_preview






var ITEMM = 0

var Item_cooldown


func local_ready():
	TYPE = "upgrade"



func _on_tree_exited():
	if previewed_card:
		previewed_card.visible = true
	
	card_layer.card_preview_is_no_longer_being_dragged()
	arena_rect.an_item_is_no_longer_being_dragged()
	abarena_rect.an_item_is_no_longer_being_dragged()
#	print("AM TARGETING??? : " + str(arena_rect.TargetingSpell))
#	arena.move_arena_back()
#	abarena.move_arena_back()
	the_button.global_lets_reshow_abilities_and_items()
	Base.unlock_pass_button()
	#because we locked it once we started dragging the preview	
	
	
