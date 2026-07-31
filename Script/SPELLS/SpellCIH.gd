extends Card_In_Hand





@export var Scene: PackedScene 			#PREVIEW WHEN DRAGGING
@export var empty_preview_scene: PackedScene	#PREVIEW WHEN HOVERED OVER

@export var Card_name = "E"
@export var Card_pfp = load("res://Assets/Textures/Missing_texture.png")
@export var Card_Cost = 1
@export var Card_XP = 2

#var UNIT = 0
#var SPELL = 1
var TYPE = "spell"
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
	
	%SPELL_JPEG.texture = Card_pfp
	%Card_description.text = SpellsDB[str(Card_name)+"_description"]
	#Yeaah, new scenes time......
	if Card_XP == 0:
		%XP.visible = false
	else:
		%XP.visible = true
		%XP.text = str(Card_XP)
	Secondary_targets = SpellsDB.SPELLS_DB[Identification][SpellsDB.BONUSTARGPOSITION]
		#this is how to acess a variable from there, not an index of list

	
	new_lane()
	
	









		
func _get_drag_data(_at_position):
	if action_and_caster_and_mana_available():
		
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
			
		
		return [TYPE,Identification, self.get_index(), cross_lane, 
		Card_from_lvlup, Secondary_targets, Is_played_on, Lobby.current_player]
	
func create_preview(ID):
	var preview = Scene.instantiate()
	assign_stats(preview,ID)
#	preview.position = UI_layer.position
	
	return preview

	


func assign_stats(preview, ID):
	preview.previewed_card = self
	preview.card_DB = SpellsDB
	preview.card_name = SpellsDB.SPELLS_DB[ID][SpellsDB.NAMEPOSITION]
	preview.card_art = Base.SPELL_TEXTURES[ID]
	preview.card_cost = SpellsDB.SPELLS_DB[ID][SpellsDB.COSTPOSITION]
	preview.card_xp = SpellsDB.SPELLS_DB[ID][SpellsDB.XPPOSITION]
	preview.Targets = SpellsDB.SPELLS_DB[ID][SpellsDB.TARGPOSITION]
	preview.cross_lane = SpellsDB.SPELLS_DB[ID][SpellsDB.CROSSLANEPOSITION]
	preview.Identification = ID	
	



#prevents from making multiple previews
var showing = 0
func _on_texture_rect_mouse_entered():
	create_empty_preview(self,Identification)
	

func _on_texture_rect_mouse_exited():
	remove_card_in_hand_preview(self)
