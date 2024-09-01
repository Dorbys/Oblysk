extends Control
@onready var arena_rect = $"SIZECHECK/ArenaRect"
@onready var arena_mid = $SIZECHECK/ArenaMid
@onready var arena_roof = $"SIZECHECK/ArenaRoof"
@onready var sizecheck = $SIZECHECK

#@onready var scrolla = self.get_parent()

var OPrena
var OP_identity

func _ready():
		if (self.get_parent().name) == "SCROLLA":
			OP_identity = 1
			
		elif (self.get_parent().name) == "SCROLLB":
			OP_identity = 0
			
		else: push_error("Arena has an identity crisis :(")
	
		OPrena = self.get_parent().get_parent().get_child(OP_identity).get_child(0)


func _on_arena_rect_child_entered_tree(_node):
	var ChildCount = arena_rect.get_child_count() 
	stretching_for_scroll(ChildCount)
	OPrena.stretching_for_scroll(ChildCount)
	
func _on_arena_rect_child_exiting_tree(_node):
	var ChildCount = arena_rect.get_child_count() 
	stretching_for_scroll(ChildCount)
	OPrena.stretching_for_scroll(ChildCount)

func stretching_for_scroll(population):
#	await get_tree().create_timer(Base.FAKE_DELTA).timeout
#	Don't rememeber why it was here

	var capacity = 7
	if population > capacity:
		self.custom_minimum_size.x = -arena_rect.OFFSET + population* (Base.CARD_WIDTH + arena_rect.OFFSET)
#		scrolla.horizontal_scroll_mode
#		print(self.custom_minimum_size.x)


func move_roof_to_front():
	sizecheck.move_child(arena_roof,2)
#	print("Frontline is now: " +str(sizecheck.get_child(2).name))
		
func move_roof_back():
	arena_rect.a_spell_is_no_longer_being_dragged()
	sizecheck.move_child(arena_roof,0)
#	print("Frontline is now: " +str(sizecheck.get_child(2).name))
#used for moving ArenaRect and ArenaRoof to the front so that spells can target units by 
#hovering over them, whereas placing units is done without cards interfering

func move_arena_mid_to_front():
	sizecheck.move_child(arena_mid,2)
#	print("Frontline is now: " +str(sizecheck.get_child(2).name))

func move_arena_mid_back():
	sizecheck.move_child(arena_mid,1)
