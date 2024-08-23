extends Card_In_Hand




@export var Scene: PackedScene 			#PREVIEW WHEN DRAGGING
@export var PreviewScene: PackedScene	#PREVIEW WHEN HOVERED OVER

@export var Card_name = "E"
@export var Card_Pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Card_Cost = 1
@export var Card_XP = 2



#var UNIT = 0
#var SPELL = 1
var TYPE = 1
var Identification = 3
var Targets = 0
var Card_from_lvlup = true
var Secondary_targets

var Is_played_on = 0

var Card_description 








func _ready():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	%XP.text = str(Card_XP)
	%SPELL_JPEG.texture = Card_Pfp
	%Card_description.text = 	LvlupDB[str(Card_name)+"_description"]
	#this is how to acess a variable from there, not an index of list
	Secondary_targets = LvlupDB.LVLUPS_DB[Identification][LvlupDB.BONUSTARGPOSITION]

	new_lane()
	
	




		
func _get_drag_data(_at_position):
	var manacheck = does_player_have_enough_mana(self)
	if manacheck == true:
		var herocheck = arena_rect.is_there_a_hero_check()
		if herocheck == true:
			Base.lock_pass_button()
			#until preview is gone
			the_button.global_lets_hide_abilities_and_items()
			if Targets == Enums.Targeting.lane:
				arena.move_roof_to_front()
				abarena.move_roof_to_front()
				

			if cross_lane == true:
				arena_rect1.a_spell_is_being_dragged(Is_played_on)
				abarena_rect1.a_spell_is_being_dragged(Is_played_on)
#				card_layer1.lets_hide_abilities_and_items()
				arena_rect2.a_spell_is_being_dragged(Is_played_on)
				abarena_rect2.a_spell_is_being_dragged(Is_played_on)
#				card_layer2.lets_hide_abilities_and_items()
				arena_rect3.a_spell_is_being_dragged(Is_played_on)
				abarena_rect3.a_spell_is_being_dragged(Is_played_on)
#				card_layer3.lets_hide_abilities_and_items()
				#this to spells later
#			else:
#				card_layer.lets_hide_abilities_and_items()
				#sets mouse filter to ignore

			if Targets == Enums.Targeting.one_unit or Targets == Enums.Targeting.one_ally:
				arena_rect.a_spell_is_being_dragged(Is_played_on)
			if Targets == Enums.Targeting.one_unit or Targets == Enums.Targeting.one_enemy:	
				abarena_rect.a_spell_is_being_dragged(Is_played_on)

				
			var drag_preview = create_preview(Identification)
			set_drag_preview(drag_preview)
			drag_preview.modulate.a = .5
				
		#	arena.move_arena_to_front()
		#	abarena.move_arena_to_front()
				
			
			return [TYPE,Identification, self.get_index(), cross_lane, 
			Card_from_lvlup, Secondary_targets, Is_played_on]
		
		else: no_hero_to_cast_this(self)
		
	else: not_enough_mana(self)
	
	#DROPDATA SPELL1 THESE: 
	#[0= TYPE, 1=Identification, 2=self.get_index(), 
	#3=crosslane, 4=Card_from_lvlup, 5 = Secondary_targets,
	#6 = Is_played_on]
	
func create_preview(ID):
	var preview = Scene.instantiate()
	assign_stats(preview,ID)
	
	return preview

	


func assign_stats(preview, ID):
	preview.Card_name = LvlupDB.LVLUPS_DB[ID][LvlupDB.NAMEPOSITION]
	preview.Card_Pfp = Base.LVLUP_CARDS_TEXTURES[ID]
	preview.Card_Cost = LvlupDB.LVLUPS_DB[ID][LvlupDB.COSTPOSITION]
	preview.Card_XP = 0
	preview.Targets = LvlupDB.LVLUPS_DB[ID][LvlupDB.TARGPOSITION]
	preview.cross_lane = LvlupDB.LVLUPS_DB[ID][LvlupDB.CROSSLANEPOSITION]
	preview.Identification = ID
	



#prevents from making multiple previews
var showing = 0
func _on_texture_rect_mouse_entered():
	print("calling there")
	create_card_in_hand_preview(self,Identification)
	

func _on_texture_rect_mouse_exited():
	remove_card_in_hand_preview(self)
	
	
func update_stats():
	Card_Cost = LvlupDB.LVLUPS_DB[Identification][LvlupDB.COSTPOSITION]
	Card_description = 	LvlupDB[str(Card_name)+"_description"]
	
func update_description():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	%XP.text = str(Card_XP)
	%SPELL_JPEG.texture = Card_Pfp
	%Card_description.text = Card_description
