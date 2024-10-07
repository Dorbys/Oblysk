extends Card_In_Hand





@export var Scene: PackedScene 			#PREVIEW WHEN DRAGGING
@export var PreviewScene: PackedScene	#PREVIEW WHEN HOVERED OVER

@export var Card_name = "E"
@export var Build_Pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Card_Cost = 1
@export var Card_XP = 2

#var UNIT = 0
#var SPELL = 1
#BUILDING = 3
var TYPE = 3
var Identification = 3
#var Affects = 0
#which lane: 0 own, 1 enemy, 2 both

var is_aura = true
var affects = "allies"
#allies enemies both

func _ready():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	%XP.text = str(Card_XP)
	%CARD_JPEG.texture = Build_Pfp
	
	%Card_description.text = BuildDB[str(Card_name)+"_description"]
	
	new_lane()
	
func new_lane():
	#this has to be called through the objects ready function, rest is prepared in class
	match Base.current_lane:
		1:
			arena = arena1
			abarena = abarena1
			arena_rect = arena_rect1
			abarena_rect = abarena_rect1
			tower_mana = tower_mana1
		2:
			arena = arena2
			abarena = abarena2
			arena_rect = arena_rect2
			abarena_rect = abarena_rect2
			tower_mana = tower_mana2
		3:
			arena = arena3
			abarena = abarena3
			arena_rect = arena_rect3
			abarena_rect = abarena_rect3
			tower_mana = tower_mana3









		
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
				arena.move_roof_to_front()
				abarena.move_roof_to_front()
				the_button.global_lets_hide_abilities_and_items()


					
				var drag_preview = create_preview(Identification)
		#		UI_layer.add_child(drag_preview)
				set_drag_preview(drag_preview)
				drag_preview.modulate.a = .5
					
			#	arena.move_arena_to_front()
			#	abarena.move_arena_to_front()
					
				
				return [TYPE,Identification, self.get_index()]
			else: you_dont_have_initiative(self)
		else: no_hero_to_cast_this(self)	
	else: not_enough_mana(self)
	
func create_preview(ID):
	var preview = Scene.instantiate()
	assign_stats(preview,ID)
	
	return preview

	


func assign_stats(preview, ID):
	preview.Card_name = BuildDB.BUILD_DB[ID][BuildDB.NAMEPOSITION]
	preview.Build_Pfp = Base.BUILDING_TEXTURES[ID]
	preview.Card_Cost = BuildDB.BUILD_DB[ID][BuildDB.COSTPOSITION]
	preview.Card_XP = BuildDB.BUILD_DB[ID][BuildDB.XPPOSITION]
#	preview.Affects = BuildDB.BUILD_DB[ID][BuildDB.AFFPOSITION]
	

#	preview.Identification = ID	
	



#prevents from making multiple previews
var showing = 0
func _on_texture_rect_mouse_entered():
#	print("calling there")
	create_card_in_hand_preview(self,Identification)
	

func _on_texture_rect_mouse_exited():
	remove_card_in_hand_preview(self)
