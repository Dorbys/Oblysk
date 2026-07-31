extends Card_In_Hand





@export var Scene: PackedScene 			#PREVIEW WHEN DRAGGING
@export var empty_preview_scene: PackedScene	#PREVIEW WHEN HOVERED OVER

@export var Card_name = "E"
@export var Card_pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Card_Cost = 1
@export var Card_XP = 2

#var UNIT = 0
#var SPELL = 1
#BUILDING = 3
var TYPE = "building"
var Identification = 3
#var Affects = 0
#which lane: 0 own, 1 enemy, 2 both

var is_aura = true
var affects = "allies"
#allies enemies both


func _ready():
	%NAME.text = Card_name
	%COST.text = str(Card_Cost)
	%CARD_JPEG.texture = Card_pfp
	
	%Card_description.text = BuildDB[str(Card_name)+"_description"]
	if Card_XP == 0:
		%XP.visible = false
	else:
		%XP.visible = true
		%XP.text = str(Card_XP)
	
	new_lane()
	








		
func _get_drag_data(_at_position):
	if action_and_caster_and_mana_available():
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
	
func create_preview(ID):
	var preview = Scene.instantiate()
	assign_stats(preview,ID)
	
	return preview

	


func assign_stats(preview, ID):
	preview.previewed_card = self
	preview.card_DB = BuildDB
	preview.card_name = BuildDB.BUILD_DB[ID][BuildDB.NAMEPOSITION]
	preview.card_art = Base.BUILDING_TEXTURES[ID]
	preview.card_cost = BuildDB.BUILD_DB[ID][BuildDB.COSTPOSITION]
	preview.card_xp = BuildDB.BUILD_DB[ID][BuildDB.XPPOSITION]
#	preview.Affects = BuildDB.BUILD_DB[ID][BuildDB.AFFPOSITION]
	

#	preview.Identification = ID	
	



#prevents from making multiple previews
var showing = 0
func _on_texture_rect_mouse_entered():
#	print("calling there")
	create_empty_preview(self,Identification)
	

func _on_texture_rect_mouse_exited():
	remove_card_in_hand_preview(self)
