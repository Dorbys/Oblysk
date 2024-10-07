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
#eg 1 unit, lane, 2 units, 1 ally
var Is_played_on = 0
# HERO or CREEP for now
var Card_from_lvlup = false

var Secondary_targets
# for cards like duel, 
#which need additional targets after they are played on a unit
#assigned in ready()

func _ready():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	%XP.text = str(Card_XP)
	%SPELL_JPEG.texture = Card_Pfp
	%Card_description.text = SpellsDB[str(Card_name)+"_description"]
	#Yeaah, new scenes time......
	Secondary_targets = SpellsDB.SPELLS_DB[Identification][SpellsDB.BONUSTARGPOSITION]
		#this is how to acess a variable from there, not an index of list
		
	new_lane()
	









		
func _get_drag_data(_at_position):
	var manacheck = does_player_have_enough_mana(self)
	if manacheck == true:
		var herocheck = arena_rect.is_there_a_hero_check()
		if herocheck == true:
			var initiative_check
			if Lobby.MULTIPLAYER == true:
				initiative_check = does_player_have_initiative()
			else:
				initiative_check = true
			if initiative_check == true:
				Base.lock_pass_button()
				#until preview is gone
				the_button.global_lets_hide_abilities_and_items()
				
				if Targets == Enums.Targeting.lane:
					arena.move_roof_to_front()
					abarena.move_roof_to_front()

				
				if Targets == Enums.Targeting.one_unit or Targets == Enums.Targeting.one_ally:
					arena_rect.a_spell_is_being_dragged(Is_played_on)
				if Targets == Enums.Targeting.one_unit or Targets == Enums.Targeting.one_enemy:	
					abarena_rect.a_spell_is_being_dragged(Is_played_on)

					
				var drag_preview = create_preview(Identification)
		#		UI_layer.add_child(drag_preview)
				set_drag_preview(drag_preview)
				drag_preview.modulate.a = .5
					
			#	arena.move_arena_to_front()
			#	abarena.move_arena_to_front()
					
				
				return [TYPE,Identification, self.get_index(),
				  cross_lane, Card_from_lvlup, Secondary_targets, 
				Is_played_on]
			else: you_dont_have_initiative(self)
			#[0= TYPE, 1=Identification, 2=self.get_index(), 
		#3=crosslane, 4=Card_from_lvlup, 5 = Secondary_targets,
		#6 = Is_played_on]
		else: no_hero_to_cast_this(self)
	else: not_enough_mana(self)
	
func create_preview(ID):
	var preview = Scene.instantiate()
	assign_stats(preview,ID)
#	preview.position = UI_layer.position
	
	return preview

	


func assign_stats(preview, ID):
	preview.Card_name = SpellsDB.SPELLS_DB[ID][SpellsDB.NAMEPOSITION]
	preview.Card_Pfp = Base.SPELL_TEXTURES[ID]
	preview.Card_Cost = SpellsDB.SPELLS_DB[ID][SpellsDB.COSTPOSITION]
	preview.Card_XP = SpellsDB.SPELLS_DB[ID][SpellsDB.XPPOSITION]
	preview.Targets = SpellsDB.SPELLS_DB[ID][SpellsDB.TARGPOSITION]
	preview.cross_lane = SpellsDB.SPELLS_DB[ID][SpellsDB.CROSSLANEPOSITION]
	preview.Identification = ID	
	



#prevents from making multiple previews
var showing = 0
func _on_texture_rect_mouse_entered():
	create_card_in_hand_preview(self,Identification)
	

func _on_texture_rect_mouse_exited():
	remove_card_in_hand_preview(self)
