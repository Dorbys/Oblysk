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

var scroll_area_top_limit:float
var scroll_area_bot_limit:float
var scroll_area_left_limit:float
var scroll_area_right_limit:float
	#used to determine whether to scroll SCROLLAs or not
	
var starting_scrollh_size_x:float

func _ready():
	new_lane()
	
	calc_scroll_area()
	starting_scrollh_size_x = scrollh.size.x
	
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
			
	calc_scroll_area()


func calc_scroll_area():
	scroll_area_top_limit = scrolla.scrolling_area.global_position.y
	scroll_area_bot_limit = scrolla.scrolling_area.global_position.y + scrolla.scrolling_area.size.y
	#push_error("scroll_area_top_limit = " +str(scroll_area_top_limit))
	#push_error("scroll_area_bot_limit = " +str(scroll_area_bot_limit))
	scroll_area_left_limit = scrolla.scrolling_area.global_position.x
	scroll_area_right_limit = scrolla.scrolling_area.global_position.x + scrolla.scrolling_area.size.x

func am_i_in_unit_scroll_area(mouse_x,mouse_y) -> bool:
	var result = mouse_y < scroll_area_bot_limit and mouse_y > scroll_area_top_limit
	result = result and mouse_x < scroll_area_right_limit
	result = result and mouse_x > scroll_area_left_limit
	return result
	
func am_i_in_hand_scroll_area(mouse_x,mouse_y) -> bool:
	var result = mouse_y > scrollh.global_position.y + camera_2d.global_position.y
	#push_error("mouse_x: " +str(mouse_x) + " ")
	result = result and mouse_x > scrollh.global_position.x + camera_2d.global_position.x
	result = result and mouse_x < scrollh.global_position.x + starting_scrollh_size_x + camera_2d.global_position.x
	return result
	
func _input(event):
	var ArenaScrollSpeed = 150
	var HandScrollSpeed = 100
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		var mouse_y = get_local_mouse_position().y
		var mouse_x = get_local_mouse_position().x
		if  viewed_lane != 4 and am_i_in_unit_scroll_area(mouse_x, mouse_y):
			#push_error("attemting to scroll lanes up, scrolla size: " +str(scrolla.size))
			scrolla.get_h_scroll_bar().value += ArenaScrollSpeed
			scrollb.get_h_scroll_bar().value += ArenaScrollSpeed
		
		elif  am_i_in_hand_scroll_area(mouse_x, mouse_y):
				
			scrollh.get_h_scroll_bar().value += HandScrollSpeed
#		print(get_h_scroll_bar().value)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		
		var mouse_y = get_local_mouse_position().y #-camera_2d.position.y
		var mouse_x = get_local_mouse_position().x #-camera_2d.position.x
		#push_error("mousey: " + str(mouse_y) + " viewed lane: " +str(viewed_lane) + " bot: " +str(scroll_area_bot_limit) +" top: " +str(scroll_area_top_limit))
		if  viewed_lane != 4 and am_i_in_unit_scroll_area(mouse_x, mouse_y):
			#push_error("attemting to scroll lanes, scrolla size: " +str(scrolla.size))
				#scrolla size remains the same, the arena size changes
			scrolla.get_h_scroll_bar().value -= ArenaScrollSpeed
			scrollb.get_h_scroll_bar().value -= ArenaScrollSpeed
			
		elif  am_i_in_hand_scroll_area(mouse_x, mouse_y):
			scrollh.get_h_scroll_bar().value -= HandScrollSpeed
#		print(get_h_scroll_bar().value)

	elif Input.is_action_just_pressed("Terminate"):
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
		if Lobby.MULTIPLAYER == false:
			the_button._on_pressed()
		elif Base.granted_action == 1: 		#Lobby.MULTIPLAYER == true
			the_button._on_pressed()
		
	elif Input.is_action_just_pressed("Show_or_hide_help"):
		%Help2.show_or_hide()
		
	elif Input.is_action_just_pressed("Show_or_hide_help_button"):
		var target = %Help
		if target.visible == true:
			target.visible = false
		else:
			target.visible = true
			
	elif Input.is_action_just_pressed("idk"):
		%idk.play()
#		if main_menu.visible == true:
#			main_menu.visible = false
#		else:
#			main_menu.visible = true
		
	elif Input.is_action_just_pressed("Reveal_game_over"):
		var target = %Game_over
		if target.over == true:
			if target.visible == true:
				target.visible = false
			else: target.visible = true
			
	elif Input.is_action_just_pressed("Switch_passing") and Base.PLAYTEST == false:
		Base.switch_passing_status()

	elif Input.is_action_just_pressed("Preview_lvlup_cards"):
		%Lvlup_cards_preview.show_or_hide()
