extends Card_In_Hand



@export var Scene: PackedScene
@export var PreviewScene: PackedScene

@export var Item_Name = "E"
@export var Item_Pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Item_Stat = 1
@export var Item_Cost = 2
var Item_cooldown = 11

#var UNIT = 0
#var SPELL = 1
var TYPE = 2
var ITEMM = 0
#ITEMM stands for whether its weapon0 special1 or armor2
#currently tring to play CARDTYPE 2 to be ITEMS
#only deckbuilding uses 2 3 4
var Identification = 3


var showing = 0
#to prevent making multiple CIH previews

var Card_from_lvlup = false
var Card_Cost = -1
#so that it doesnt trigger manaspending

func _ready():
	%NAME.text = Item_Name
	
	%COST.text = str(Item_Cost)
	%WEAPON_JPEG.texture = Item_Pfp
	
	%STATS.text = ItemsDB[str(Item_Name)+"_description"]
	
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
	Base.lock_pass_button()
	#until preview is gone
	var drag_preview = create_preview(Identification)
#	UI_layer.add_child(drag_preview)
	set_drag_preview(drag_preview)
	drag_preview.modulate.a = .5

	arena_rect.an_item_is_being_dragged()
	abarena_rect.an_item_is_being_dragged()
	the_button.global_lets_hide_abilities_and_items()
#	arena.move_arena_to_front()
#	abarena.move_arena_to_front()
	
	
	return [TYPE,Identification, self.get_index(), cross_lane]

func create_preview(ID):
	var preview = Scene.instantiate()
	assign_stats(preview,ID)

	return preview
	
func assign_stats(preview, ID):
	preview.Item_Name = ItemsDB.ITEMS_DB[ID][ItemsDB.NAMEPOSITION]
	preview.ITEMM = ItemsDB.ITEMS_DB[ID][ItemsDB.ITEMMPOSITION]
	preview.Item_Pfp = Base.ITEM_TEXTURES[ID]
	preview.Item_Stat = ItemsDB.ITEMS_DB[ID][ItemsDB.STATPOSITION]
	preview.Item_Cost = ItemsDB.ITEMS_DB[ID][ItemsDB.COSTPOSITION]
	preview.Item_cooldown = ItemsDB.ITEMS_DB[ID][ItemsDB.COOLDOWNPOSITION]
	preview.Identification = ID


func _on_texture_rect_mouse_entered():
	create_card_in_hand_preview(self,Identification)


func _on_texture_rect_mouse_exited():
	remove_card_in_hand_preview(self)
