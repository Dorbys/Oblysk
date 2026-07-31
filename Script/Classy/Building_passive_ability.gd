extends Node

class_name Building_passive_ability

@onready var tower_layer = $"../../../../"
@onready var BUTTON = $"../../../../../../UI_layer/THE_BUTTON"
@onready var effect_layer = $"../../../../../../Effect_layer"

var house
	#building alternative to wielder
	#given by building itself during _ready()



var TYPE = "building"
	#despite this not being building node, but building/control (for ability)
	#it's the part that has to be checked for type
	#and doesn't need basic_requirements() check

var projectile

var custom_projectile_texture
	#used when Projectile_3_base is used as projectile
		#cuz it accepts anything" as texture
var custom_projectile_speed

func projectile_animation( caster_position, target_position):
	var another = projectile.instantiate()
	if custom_projectile_texture:
		another.new_texture = custom_projectile_texture
	if custom_projectile_speed:
		another.new_speed = custom_projectile_speed
	another.global_position = caster_position
	another.destination = target_position
	effect_layer.add_child(another)	
	while another.finished == false:
		await get_tree().create_timer(Base.FAKE_DELTA).timeout	
