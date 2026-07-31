extends Control



class_name  Unit_passive_ability

var TYPE = "unit_passive_ability"
	#just because TYPE will be compared in Signal_Hub

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

var projectile

var custom_projectile_texture
	#used when Projectile_3_base is used as projectile
		#cuz it accepts anything" as texture
var custom_projectile_speed
	

func wait_for_wielder_to_be_readied():
	var attempts = 30
	while wielder.readied == false:
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		attempts -= 1
		if attempts == 0:
			push_error("attempts depleted")
			break

func projectile_animation( caster_position, target_position):
	var another = projectile.instantiate()
	if custom_projectile_texture:
		another.new_texture = custom_projectile_texture
	if custom_projectile_speed:
		another.new_speed = custom_projectile_speed
	another.global_position = caster_position
	another.destination = target_position
	wielder.effect_layer.add_child(another)	
	while another.finished == false:
		await get_tree().create_timer(Base.FAKE_DELTA).timeout	
