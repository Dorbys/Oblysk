#@tool
# https://www.gdquest.com/library/laser_2d/#code-reference

extends RayCast2D
@onready var annihilate_vfx: Control = $"../.."

## Speed at which the laser extends when first fired, in pixels per seconds.
@export var cast_speed := 7000
## Maximum length of the laser in pixels.
@export var max_length := -980
### Distance in pixels from the origin to start drawing and firing the laser.
#@export var start_distance := 40.0
## Base duration of the tween animation in seconds.
@export var growth_time := 0.1
#@export var color := Color.WHITE: set = set_color

## If `true`, the laser is firing.
## It plays appearing and disappearing animations when it's not animating.
## See `appear()` and `disappear()` for more information.
#@export var is_casting := false: set = set_is_casting

var tween: Tween = null

@onready var line_2d: Line2D = %Line2D
#@onready var casting_particles: GPUParticles2D = %CastingParticles2D
#@onready var collision_particles: GPUParticles2D = %CollisionParticles2D
#@onready var beam_particles: GPUParticles2D = %BeamParticles2D
#
#var line_width = 10

var laser_duration = 0.5


func _ready() -> void:
	set_physics_process(false)
	#set_color(color)
	#set_is_casting(is_casting)
	line_2d.points[0] = Vector2(0.0,0.0)
	line_2d.points[1] = Vector2.ZERO
	#await get_tree().create_timer(1).timeout
	#await get_tree().create_timer(0.4).timeout
	#appear()
	set_physics_process(true)
	await get_tree().create_timer(laser_duration*0.8).timeout
	annihilate_vfx.stop_emiting()
	await get_tree().create_timer(laser_duration*0.2).timeout
	disappear()
	#line_2d.visible = false
	#casting_particles.position = line_2d.points[0]


func _physics_process(delta: float) -> void:
	target_position.y = move_toward(
		target_position.y,
		max_length,
		cast_speed * delta
	)
	#push_error(str(target_position))
	if target_position.y >= 0.9 *max_length:
		annihilate_vfx.laser_max_length_reached()
		
	#var laser_end_position := target_position
	force_raycast_update()
	
	#if is_colliding():
		#laser_end_position = to_local(get_collision_point())
		#collision_particles.global_rotation = get_collision_normal().angle()
		#collision_particles.position = laser_end_position

	line_2d.points[1] = target_position

	#var laser_start_position := line_2d.points[0]
	#beam_particles.position = laser_start_position + (laser_end_position - laser_start_position) * 0.5
	#beam_particles.process_material.emission_box_extents.x = laser_end_position.distance_to(laser_start_position) * 0.5
#
	#collision_particles.emitting = is_colliding()


#func set_is_casting(new_value: bool) -> void:
	#if is_casting == new_value:
		#return
	#is_casting = new_value
	#set_physics_process(is_casting)
#
	#if beam_particles == null:
		#return
#
	#beam_particles.emitting = is_casting
	#casting_particles.emitting = is_casting
#
	#if is_casting:
		#var laser_start := Vector2.RIGHT * start_distance
		#line_2d.points[0] = laser_start
		#line_2d.points[1] = laser_start
		#casting_particles.position = laser_start
#
		#appear()
	#else:
		#target_position = Vector2.ZERO
		#collision_particles.emitting = false
		#disappear()


#func appear() -> void:
	#line_2d.visible = true
	#if tween and tween.is_running():
		#tween.kill()
	#tween = create_tween()
	#tween.tween_property(line_2d, "width", line_width, growth_time).from(0.0)
#
#
func disappear() -> void:
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(line_2d, "width", 0.0, growth_time).from_current()
	tween.tween_callback(line_2d.hide)
	await tween.finished
	annihilate_vfx.laser_finished()
#
#
#func set_color(new_color: Color) -> void:
	#color = new_color
#
	#if line_2d == null:
		#return
#
	#line_2d.modulate = new_color
	#casting_particles.modulate = new_color
	#collision_particles.modulate = new_color
	#beam_particles.modulate = new_color
