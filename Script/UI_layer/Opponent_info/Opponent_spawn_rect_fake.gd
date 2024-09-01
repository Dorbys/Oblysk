extends Control

@onready var spawn_rect = %SpawnRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func collide_units():
#	colliding_units += 1
	#increased when the child enters tree
	var collide_time = 0.2
	var target
	var destinationX
	var offset = (0.5 * Base.CARD_WIDTH)
	var center = (size.x)/2
	

	
			
	var population = get_child_count()
	var mid = ceil(population/2)
	
	for i in population:

		
			
		target = get_child(i)
		
#		if skip_target != -1 and i> skip_target:
#			i -= 1
#			#modifies the placement of following cards, but still targets the right
#			#child since the "skipped one" is still present
			
		if population%2 == 0:
			destinationX = center - offset + ((i+1-mid) * Base.CARD_WIDTH * 0.5) #0.5 cuz scale

		else:
			destinationX =  center + ((i-mid) * Base.CARD_WIDTH * 0.5) #cuz scale

		var tween = create_tween().set_parallel(true)
		tween.tween_property(target,"position",
		 Vector2(destinationX,0),
		 collide_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		
	await get_tree().create_timer(collide_time).timeout
	spawn_rect.colliding_units -= 1

func _on_child_entered_tree(node):
	spawn_rect.colliding_units += 1
	node.scale = Vector2(0.5,0.5)
	await collide_units()
