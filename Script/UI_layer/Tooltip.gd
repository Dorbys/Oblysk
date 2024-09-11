class_name Tooltip
extends Node

#https://www.youtube.com/watch?v=eOVvI1ztcPg

#####################################
# SIGNALS
#####################################

#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
@export var visuals_res: PackedScene
@export var owner_node: Node
@export_range (0.0, 10.0, 0.05) var show_delay = 0.5
@export var follow_mouse: bool = true
@export_range(0, 100, 1)  var offset_x: float
@export_range(0, 100, 1) var offset_y: float
@export_range(0, 100, 1) var padding_x: float
@export_range(0, 100, 1) var padding_y: float


#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
var _visuals: Control
var _timer: Timer
#var base_camera = null
var tooltip_parent = null
var UI_layer = null
var my_text = null

#####################################
# ONREADY VARIABLES
#####################################
@onready var offset: Vector2 = Vector2(offset_x, offset_y)
@onready var padding: Vector2 = Vector2(padding_x, padding_y)
@onready var extents: Vector2



#####################################
# OVERRIDE FUNCTIONS
#####################################
func _init() -> void:
	pass


func _ready() -> void:
	set_process(false)
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
#	set_process(true)
	#so that we get nodes that we require from parent after parent is 
		#fully initialised
	tooltip_parent = get_parent()
#	base_camera = get_parent().camera_for_tooltip
# 	we don't neet camera if we put tooltip onto UI_layer
	UI_layer = tooltip_parent.UI_layer
	my_text = tooltip_parent.text_for_tooltip
	
	
	# connect signals
	owner_node.mouse_entered.connect(_mouse_entered)
	owner_node.mouse_exited.connect(_mouse_exited)
	# initialize the timer
	_timer = Timer.new()
	UI_layer.add_child(_timer)
	_timer.timeout.connect(_delayed_show)



func _process(_delta: float) -> void:
#	if _visuals.visible:
#		var cam_pos = base_camera.global_position
		var border = Vector2(get_viewport().size)  - padding
		
		var base_pos = _get_screen_pos()
		# test if need to display to the left
		var final_x = base_pos.x + offset.x 
		if final_x + extents.x > border.x:
			final_x = base_pos.x - offset.x - extents.x
		# test if need to display below
		var final_y = base_pos.y - extents.y - offset.y 
		if final_y < padding.y:
			final_y = base_pos.y + offset.y
		_visuals.global_position = Vector2(final_x, final_y)  
		


#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################
func _mouse_entered() -> void:
	_timer.start(show_delay)


func _mouse_exited() -> void:
	_timer.stop()
	if _visuals != null:
		_visuals.hide()
	set_process(false)


func _delayed_show() -> void:
	_timer.stop()
	# update the text to what it is now since this is used for both static and dynamic tooltips
	my_text = tooltip_parent.text_for_tooltip
	
	# create the visuals
	_visuals = visuals_res.instantiate()
	_visuals.visible = false
	_visuals.caller = self
	#set the text
	UI_layer.add_child(_visuals)
	_visuals.get_child(1).text = my_text
	extents = _visuals.size
	set_process(true)
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout
	_visuals.visible = true
	
	
	
	
	
	
#	# calculate the extents
#	extents = _visuals.size



func _get_screen_pos() -> Vector2:
	if follow_mouse:
		return get_viewport().get_mouse_position()
	
	
	var position = Vector2()
	
	if owner_node is Node2D:
		position = owner_node.get_global_transform_with_canvas().origin
#	elif owner_node is Spatial:
#		position = get_viewport().get_camera().unproject_position(owner_node.global_transform.origin)
	#3D stuff ig
	elif owner_node is Control:
		position = owner_node.get_global_transform_with_canvas().origin
		#idk what this does but it's exactly what I need
			#we working without follow mouse
		
	return position































#func _on_tree_exited():
#	visuals_res.queue_free()
#	_timer.queue_free()
