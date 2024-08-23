extends Card_preview


@export var Item_Name = "E"
@export var Item_Pfp = load("res://Assets/CardsPNGS/FAKE.jpg")
@export var Item_Stat = 1
@export var Item_Cost = 2
var Item_cooldown

#var UNIT = 0
#var SPELL = 1
var TYPE = 2
var ITEMM = 0
var Identification = 3


func _ready():
	%NAME.text = Item_Name
	%COST.text = str(Item_Cost)
	%WEAPON_JPEG.texture = Item_Pfp
	%STATS.text = ItemsDB[str(Item_Name)+"_description"]
	
	new_lane()
	
func new_lane():
	match Base.current_lane:
		1:
			arena = arena1
			abarena = abarena1
			arena_rect = arena_rect1
			abarena_rect = abarena_rect1
		2:
			arena = arena2
			abarena = abarena2
			arena_rect = arena_rect2
			abarena_rect = abarena_rect2

		3:
			arena = arena3
			abarena = abarena3
			arena_rect = arena_rect3
			abarena_rect = abarena_rect3


func _on_tree_exited():
#	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	

	arena_rect.an_item_is_no_longer_being_dragged()
	abarena_rect.an_item_is_no_longer_being_dragged()
#	print("AM TARGETING??? : " + str(arena_rect.TargetingSpell))
#	arena.move_arena_back()
#	abarena.move_arena_back()
	the_button.global_lets_reshow_abilities_and_items()
	Base.unlock_pass_button()
	#because we locked it once we started dragging the preview	
	
	
