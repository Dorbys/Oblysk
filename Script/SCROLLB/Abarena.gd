extends BoxContainer


@onready var abarena_rect = $SIZECHECK/AbarenaRect
#@onready var abarena_rect = 
@onready var scrollb = $".."




func _on_abarena_rect_child_entered_tree(_node):
	stretching_for_scroll()

func _on_abarena_rect_child_exiting_tree(_node):
	stretching_for_scroll()

func stretching_for_scroll():
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	var ChildCount = abarena_rect.get_child_count() 
	var capacity = 8
	if ChildCount > capacity:
		self.custom_minimum_size.x = abarena_rect.STARTSET + ChildCount* (Base.CARD_WIDTH + abarena_rect.OFFSET)
#		print(self.custom_minimum_size.x)
