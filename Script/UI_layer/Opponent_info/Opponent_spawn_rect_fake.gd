extends Control

@onready var spawn_rect = %SpawnRect

var colliding_units = 0
#to know whether I can make Spawner visible already
#count of how many units still moving to hide their movement





#func collide_units():
	##I don't think this needs tweens
	#var collide_time = 0.2
	#var target
	#var destinationX
	#var offset = (0.5 * Base.CARD_WIDTH)
	#var center = (size.x)/2
	#
#
	#
			#
	#var population = get_child_count()
	#var mid = ceil(population/2)
	#if population == 4:
		#center += 0.25 * Base.CARD_WIDTH #cuz scaled size
	#elif population == 5:
		#center += 0.5 * Base.CARD_WIDTH
		#
	#for i in population:
#
		#
			#
		#target = get_child(i)
		#
##		if skip_target != -1 and i> skip_target:
##			i -= 1
##			#modifies the placement of following cards, but still targets the right
##			#child since the "skipped one" is still present
			#
		#if population%2 == 0:
			#destinationX = center - offset + ((i+1-mid) * Base.CARD_WIDTH * 0.5) #0.5 cuz scale
#
		#else:
			#destinationX =  center + ((i-mid) * Base.CARD_WIDTH * 0.5) #cuz scale
#
		#var tween = create_tween().set_parallel(true)
		#tween.tween_property(target,"position",
		 #Vector2(destinationX,0),
		 #collide_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		#
	#colliding_units -= 1

#func _on_child_entered_tree(node):
#	spawn_rect.colliding_units += 1
#

func collide_units(skip_target = -1):
	#just copied from SpawnRect
	var collide_time = 0.2
	var destination_X = 0
	var population = get_child_count()
	var center = (size.x)/2
	var gap = 6
	var target 
	var tween

	
	tween = get_tree().create_tween().set_parallel(true)
	tween.pause()
	
	for i in population:
		if i == skip_target:
			continue
		
			
		target = get_child(i)
		
		if skip_target != -1 and i> skip_target:
			i -= 1
			#modifies the placement of following cards, but still targets the right
			#child since the "skipped one" is still present
			

		destination_X = center + (i * Base.CARD_WIDTH * Base.pre_deploy_scale_down	)
		if i > 0:
			destination_X += gap*i
		#push_error("destinationX = " +str(destination_X))

		tween.tween_property(target,"position",Vector2(destination_X,0),collide_time)
#			tween.tween_property(target,"scale",Vector2(scale_down,scale_down),movement_time)

	tween.play()
	if colliding_units > 0 : 
		colliding_units -= 1

func clear_draggable_heroes():
	#since joiner doesnt actually deploy, deploy rects need to clean up
	for i in range(get_child_count() - 1, -1, -1):
		var target = get_child(i)
		if target.HERO == true:
			target.appear_alive()
			#target.leave_draggable_state()


func _on_child_entered_tree(node):
	colliding_units += 1
	node.pre_deploy_respawn()
	node.scale = Vector2(Base.pre_deploy_scale_down, Base.pre_deploy_scale_down)
	collide_units()
