extends Card_preview






var Targets = 0
var Secondary_targets

var cross_lane

func local_ready():
	TYPE = "spell"
	Secondary_targets = SpellsDB.SPELLS_DB[Identification][SpellsDB.BONUSTARGPOSITION]
	
func _on_tree_exited():
	if previewed_card:
		previewed_card.visible = true
				
	card_layer.card_preview_is_no_longer_being_dragged()
	if Targets == Enums.Targeting.lane:
		arena.move_roof_back()
		abarena.move_roof_back()
		#moving roof back automatically sets TargetingSpell to 0
		
	elif Secondary_targets == Enums.Targeting.none:
	#	print("AM TARGETING??? : " + str(arena_rect.TargetingSpell))
#		arena.move_arena_back()
#		abarena.move_arena_back()
		if cross_lane == true:
			#if it was crosslane, reshow in all lanes
			arena_rect1.a_spell_is_no_longer_being_dragged()
			abarena_rect1.a_spell_is_no_longer_being_dragged()
#			card_layer1.lets_reshow_abilities_and_items()
			
			arena_rect2.a_spell_is_no_longer_being_dragged()
			abarena_rect2.a_spell_is_no_longer_being_dragged()
#			card_layer2.lets_reshow_abilities_and_items()
			
			arena_rect3.a_spell_is_no_longer_being_dragged()
			abarena_rect3.a_spell_is_no_longer_being_dragged()
#			card_layer3.lets_reshow_abilities_and_items()
		else:
			arena_rect.a_spell_is_no_longer_being_dragged()
			abarena_rect.a_spell_is_no_longer_being_dragged()
#			card_layer.lets_reshow_abilities_and_items()
		
	else: 
		card_layer.card_preview_targeting_non_single_exits_tree()
		#Unit code takes care of resolving the spell effect by creating Covering:
		#in Unit._drop_data
		#this also sets TargetingSpell to 0 on its own

#	else: print("unknown targeting_now value in card layer")
	the_button.global_lets_reshow_abilities_and_items()
	Base.unlock_pass_button()
	#because we locked it once we started dragging the preview
	
