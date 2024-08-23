extends TextureRect

#I think this is the old testing stuff, but not gonna test out now


@export var Scene: PackedScene

signal card_carried
	#Empty signal = nothing being send, just signal, if signal has smt
	#and receiving func wants something it can take the thing being sent
	# and just work with it, so idk where delta is still



	
var CardsDrawn = 0
#


func _get_drag_data(_at_position):
	var WhichCard = Base.PlayerDeck[CardsDrawn% len(Base.PlayerDeck)]
	
	var drag_preview = create_preview(WhichCard)
#	await get_tree().create_timer(3).timeout
	set_drag_preview(drag_preview)
	
	drag_preview.modulate.a = .5
	
	CardsDrawn += 1
#	set_process(true)
	emit_signal("card_carried")
#	print(drag_preview.get_parent())
	return WhichCard

func create_preview(ID):
	var preview = Scene.instantiate()
	preview.Unit_Name = Base.UNIT_STATS[ID][Base.NAMEPOSITION]
	preview.Unit_Pfp = Base.UNIT_TEXTURES[ID]
	preview.Unit_Attack = Base.UNIT_STATS[ID][Base.ATTACKPOSITION]
	preview.Unit_Health = Base.UNIT_STATS[ID][Base.HEALTHPOSITION]
	
	return preview
