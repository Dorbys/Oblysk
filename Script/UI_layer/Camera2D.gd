extends Camera2D

@onready var oblysk = $".."
@onready var UI_layer = $"../UI_layer"
@onready var the_button = %THE_BUTTON

#@onready var camera_2d = %Camera2D

var zoomed_out = false
var my_scale = 3.12
var camera_zoom = Vector2(0.3204,0.3204)
#so many decimal numbers so that it looks like camera scales together
	#aka ui doesnt slide
var move_time_long = 1
var move_time_short = 0.4
#was 0.52

var moving = false
#to prevent multiple presses making animation ugly


func move_camera_to_lane(number):
	if moving == false:
		if number != Base.viewed_lane:
			remove_tooltips()
		if number == Base.current_lane:
			%Active_lane.visible = false
		else:
			%Active_lane.visible = true
		if zoomed_out == true:
			camera_zoom_in()
		moving = true
		the_button.global_zoom_clicking_lanes_impossible()
		match number:
			1:
				var tween = create_tween()
				tween.tween_property(self,"position",Base.LANE1_COORDINATES,move_time_short)
				
				Base.viewed_lane = 1
				oblysk.new_lane()
				#making sure we can scroll only what should be capable now
			2:			
				var tween = create_tween()
				tween.tween_property(self,"position",Base.LANE2_COORDINATES,move_time_short)
				
				Base.viewed_lane = 2
				oblysk.new_lane()
				#making sure we can scroll only what should be capable now
			3:
				var tween = create_tween()
				tween.tween_property(self,"position",Base.LANE3_COORDINATES,move_time_short)
				
				Base.viewed_lane = 3
				oblysk.new_lane()
				#making sure we can scroll only what should be capable now
			4:
				moving = false
				camera_zoom_out()
			_:
				
				print("UI_layer doesn't know where it should move camera to")
		await get_tree().create_timer(move_time_short).timeout 
		moving = false
				
			
func camera_zoom_out():
	#in keyboard input this is acessed directly instead of moving lane to 4
	#because that would make it possible for starting the movement of cam 
	#before it finished its current move
	if moving == false:
		if Base.current_lane != 4:
			%Active_lane.visible = true
		else: 
			%Active_lane.visible = false
		remove_tooltips()
		
		moving = true
		zoomed_out = true
	#	scale = Vector2(my_scale, my_scale)
	#	set_zoom(Vector2(camera_zoom,camera_zoom))
		var tween = create_tween().set_parallel(true)
		tween.tween_property(self,"zoom",camera_zoom,move_time_short)
		tween.tween_property(self,"position",Base.ZOOM_COORDINATES,move_time_short)	
		
		Base.viewed_lane = 4
		oblysk.new_lane()
		#making sure we can scroll only what should be capable now
		
		await get_tree().create_timer(move_time_short).timeout 
		moving = false
		the_button.global_zoom_clicking_lanes_possible()
		
func camera_zoom_in():
#	scale = Vector2(1,1)
	if moving == false:
		moving = true
		var tween = create_tween()
		tween.tween_property(self,"zoom",Vector2(1,1),move_time_short)
		zoomed_out = false
		await get_tree().create_timer(move_time_short).timeout 
		moving = false


func remove_tooltips():
	if UI_layer.has_node("Tooltip_container"):
		var target = UI_layer.get_node("Tooltip_container")
		target.disappear_when_THE_BUTTON_is_pushed()
		#to get rid of tooltips


func _on_active_lane_pressed():
	move_camera_to_lane(Base.current_lane)
