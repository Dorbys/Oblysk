extends Control


@onready var help_holder: Control = $Help_holder
var currently_viewed_help = 0
var help_id_max: int

func _ready() -> void:
	help_id_max = help_holder.get_child_count() - 1
	
func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("Show_or_hide_help"):
		#if visible:
			#visible = false
		#else:
			#visible = true
			
	if visible:
		if Input.is_action_just_pressed("ui_right"):
			move_to_next_slide()
		elif Input.is_action_just_pressed("ui_left"):
			move_to_previous_slide()
		elif Input.is_action_just_pressed("ui_cancel"):
			visible = false
			
			
func move_to_next_slide():
	help_holder.get_child(currently_viewed_help).visible = false
	currently_viewed_help += 1
	if currently_viewed_help > help_id_max:
		currently_viewed_help = help_id_max
	help_holder.get_child(currently_viewed_help).visible = true
	
func move_to_previous_slide():
	help_holder.get_child(currently_viewed_help).visible = false
	currently_viewed_help -= 1
	if currently_viewed_help < 0:
		currently_viewed_help = 0
	help_holder.get_child(currently_viewed_help).visible = true
		
		
		

func _on_close_button_pressed() -> void:
	visible = false


func _on_help_pressed() -> void:
	visible = true

func show_or_hide():
	push_error("showorhiding: " +str(visible))
	if visible == false:
		visible = true
	else:
		visible = false
