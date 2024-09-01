extends BoxContainer

@onready var scrollh = $".."
@onready var hand_rect = $SIZECHECK/HandRect


#takes care of the scrollable size


func _on_hand_rect_child_entered_tree(_node):
	Resize_HANDA()

func _on_hand_rect_child_exiting_tree(_node):
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	# (so that cards that use queue free have time to dissapear
	Resize_HANDA()
	
var handwidth = 1200	
var limit 
var capacity = 8
func Resize_HANDA():
	limit = %HandRect.limit
	var ChildCount = hand_rect.get_child_count() 
	if ChildCount > capacity:
		self.custom_minimum_size.x =  + ((ChildCount) * limit) + (0.4 * Base.CARD_WIDTH) + 2.5*%HandRect.startset
												#always 		#orig +0.1 + 0.5
#		print("min size HANDA: " + str(self.custom_minimum_size.x))
		
	else:
		self.custom_minimum_size.x = handwidth
		
		
		


#var handstart = mid - (handwidth/2)



