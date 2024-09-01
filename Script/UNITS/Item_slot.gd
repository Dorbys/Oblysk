extends TextureRect

#@onready var card_layer = 	$"../../../../../.."
@onready var UI_layer = 		$"../../../../../../../../UI_layer"
@onready var camera = 		$"../../../../../../../../Camera2D"
@onready var wielder = $".."

#I should call child when clicked if the child made me visible
@onready var cooldown_node = get_child(0)
@onready var tooltip_node = get_child(1)

var has_active_item = false
var CooldownM
var CooldownC
var text_for_tooltip = "tooltip didn't load properly"
var connectionT = 0

func item_equipped():
	reshow_myself()
	#for tooltip to be able to be shown
		#clicking should still be impossible

func active_item_equipped(cooldown):
	has_active_item = true
	CooldownM = cooldown
	await prepare_cooldown()
	
	tries = 3
	
	item_equipped()
	
func active_item_unequipped():
	cooldown_node.visible = false
	has_active_item = false
	hide_myself()
	tries = 1



var tries = 3
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var target = get_child(2)
		#child 0 is cooldown now, 1 is tooltipper
		if target.has_method("item_clicked"):
			target.item_clicked()
		else:
			tries -= 1
			if tries > -1:
				await get_tree().create_timer(Base.FAKE_DELTA).timeout 
				_on_gui_input(event)
			else:
				push_error("ran out of tries in: " +str(name))
	
func prepare_cooldown():
	#for when active item is equipped it should be ready to use
	CooldownC = 0
	reconnect_myself()

func activate_cooldown():
	hide_myself()
	CooldownC = CooldownM
	cooldown_node.text = str(CooldownC)
	cooldown_node.visible = true
	disconnect_myself()

func decrease_cooldown():
	if has_active_item == true:
		CooldownC -= 1
		
		if CooldownC == 0:
			cooldown_node.visible = false
			reshow_myself()
		cooldown_node.text = str(CooldownC)

#func check_cooldown_penetrability():
#	if Base.current_lane == wielder.my_lane:
#		reshow_myself()
#	else:
#		hide_myself()

func check_cooldown_penetrability():
	if has_active_item == true and CooldownC < 1:
		if Base.current_lane == wielder.my_lane:
			reconnect_myself()
		else:
			disconnect_myself()

func disconnect_myself():
	if connectionT == 1:
	#Because I have no idea how to check wheter its DISCONNECTED
		disconnect("gui_input", _on_gui_input)
		connectionT = 0
		mouse_default_cursor_shape = Control.CURSOR_ARROW

func reconnect_myself():
	if connectionT == 0:
		#Because I have no idea how to check wheter its DISCONNECTED
		connect("gui_input", _on_gui_input)
		connectionT = 1
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND






func hide_myself():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#THIS NECCESARY WHEN TEXTURE ISNT THE SAME AS IN THE SCENE
		#But not in every case wtf
	tooltip_node.mouse_filter = MOUSE_FILTER_IGNORE
	

	
func reshow_myself():
	if has_active_item == true and CooldownC < 1:
		self.mouse_filter = Control.MOUSE_FILTER_STOP
		
	if get_child_count()> 2:
		tooltip_node.mouse_filter = MOUSE_FILTER_PASS
