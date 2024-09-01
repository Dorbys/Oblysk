extends Control

@onready var camera_2d = %Camera2D
@onready var scrollh = %SCROLLH
@onready var the_button = $UI_layer/THE_BUTTON

@onready var scrolla1 = $First_lane/Card_layer/SCROLLA
@onready var scrollb1 = $First_lane/Card_layer/SCROLLB

@onready var scrolla2 = $Mid_lane/Card_layer/SCROLLA
@onready var scrollb2 = $Mid_lane/Card_layer/SCROLLB

@onready var scrolla3 = $Last_lane/Card_layer/SCROLLA
@onready var scrollb3 = $Last_lane/Card_layer/SCROLLB



var scrolla
var scrollb

#var current_lane = Base.current_lane
var viewed_lane = Base.viewed_lane



func _ready():
	new_lane()
	
func new_lane():
	viewed_lane = Base.viewed_lane
	match viewed_lane:
		#INTENTIONALY BECAUSE SCROLLING IS DEPENDENT ON CAMERA
		1:
			scrolla = scrolla1
			scrollb = scrollb1
		2:
			scrolla = scrolla2
			scrollb = scrollb2
		3:
			scrolla = scrolla3
			scrollb = scrollb3
		4:
			print("You can't scroll lanes while viewing lane4")




func _input(event):
	var ArenaScrollSpeed = 150
	var HandScrollSpeed = 100
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		var MOUSEY = get_local_mouse_position().y-camera_2d.position.y
		var MOUSEX = get_local_mouse_position().x-camera_2d.position.x
		if  viewed_lane != 4 and MOUSEY > scrollb.position.y and MOUSEY < scrolla.position.y+Base.CARD_HEIGHT:
			scrolla.get_h_scroll_bar().value += ArenaScrollSpeed
			scrollb.get_h_scroll_bar().value += ArenaScrollSpeed
		
		if  (MOUSEY > scrollh.position.y+363 and MOUSEX > scrollh.position.x 
			and MOUSEX < scrollh.position.x + scrollh.size.x):
				
			scrollh.get_h_scroll_bar().value += HandScrollSpeed
#		print(get_h_scroll_bar().value)
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	elif Input.is_action_just_pressed("Camera_Lane_1"):
		%Camera2D.move_camera_to_lane(1)
	elif Input.is_action_just_pressed("Camera_Lane_2"):
		%Camera2D.move_camera_to_lane(2)
	elif Input.is_action_just_pressed("Camera_Lane_3"):
		%Camera2D.move_camera_to_lane(3)
	elif Input.is_action_just_pressed("Camera_zoom_out"):
		%Camera2D.move_camera_to_lane(4)
	
	elif Input.is_action_just_pressed("THE"):
		the_button._on_pressed()
		
	elif Input.is_action_just_pressed("Show_or_hide_help"):
		%Help_screen.show_or_hide()
		
	elif Input.is_action_just_pressed("Show_or_hide_help_button"):
		var target = %Help
		if target.visible == true:
			target.visible = false
		else:
			target.visible = true
			
	elif Input.is_action_just_pressed("idk"):
		%idk.play()
		
	elif Input.is_action_just_pressed("Reveal_game_over"):
		var target = %Game_over
		if target.over == true:
			if target.visible == true:
				target.visible = false
			else: target.visible = true

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		var MOUSEY = get_local_mouse_position().y-camera_2d.position.y
		var MOUSEX = get_local_mouse_position().x-camera_2d.position.x
		if  viewed_lane != 4 and MOUSEY > scrollb.position.y and MOUSEY < scrolla.position.y+Base.CARD_HEIGHT:
			scrolla.get_h_scroll_bar().value -= ArenaScrollSpeed
			scrollb.get_h_scroll_bar().value -= ArenaScrollSpeed
			
		if  (MOUSEY > scrollh.position.y and MOUSEX > scrollh.position.x 
			and MOUSEX < scrollh.position.x + scrollh.size.x):
			scrollh.get_h_scroll_bar().value -= HandScrollSpeed
#		print(get_h_scroll_bar().value)


