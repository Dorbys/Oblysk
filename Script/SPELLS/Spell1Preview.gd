extends Card_preview




								#CARE to not put / at the start smh
#@export var Scene: PackedScene

@export var Card_name = "E"
@export var Card_Pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Card_Cost = 1
@export var Card_XP = 2

#var UNIT = 0
#var SPELL = 1
var TYPE = 1
var Identification = 3
var Targets = 0
var Secondary_targets

var cross_lane

func _ready():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	%XP.text = str(Card_XP)
	%SPELL_JPEG.texture = Card_Pfp
	%Card_description.text = SpellsDB[str(Card_name)+"_description"]
	Secondary_targets = SpellsDB.SPELLS_DB[Identification][SpellsDB.BONUSTARGPOSITION]


	
	new_lane()
	
func new_lane():
	match Base.current_lane:
		1:
			arena = arena1
			abarena = abarena1
			arena_rect = arena_rect1
			abarena_rect = abarena_rect1
			card_layer = card_layer1
		2:
			arena = arena2
			abarena = abarena2
			arena_rect = arena_rect2
			abarena_rect = abarena_rect2
			card_layer = card_layer2

		3:
			arena = arena3
			abarena = abarena3
			arena_rect = arena_rect3
			abarena_rect = abarena_rect3
			card_layer = card_layer3
	
func _on_tree_exited():
	
				
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
	
