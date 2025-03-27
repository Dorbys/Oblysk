extends Control

@export var played_card_scene: PackedScene

var TYPE = "building"
	#it doesn't but it let's me pass the check whether to send signal here
var animation_time = 0.25
var rotation_time = 0.15

var starting_x:int


func _ready():
	starting_x = position.x
	#Tower_layer appends me to card_played list


func card_has_been_played(card:Node):
	var card_icon = played_card_scene.instantiate()
	card_icon.card_type = card.TYPE
	card_icon.card_ID = card.Identification
	card_icon.texture = card.Card_pfp
	
	%History.add_child(card_icon)
	if Lobby.MULTIPLAYER == true:
		mirror_played_card(card.TYPE,card.Identification)
			#can't send 'card' cuz nodes can't be rpced

@rpc("any_peer", "call_remote", "reliable")
func mirror_played_card(card_type, card_ID):
	if multiplayer.get_remote_sender_id() == 0:
		#called locally
		push_error("rpcing mirror_played_card")
		rpc_id(Lobby.opponent_peer_id,"mirror_played_card",card_type, card_ID)
	else:
		push_error("rpc of mirror_played_card received")
		var card_icon = played_card_scene.instantiate()
		card_icon.card_type = card_type
		card_icon.card_ID = card_ID
		var db = extract_texture_db_from_card_type(card_type)
		card_icon.texture = db[card_ID]
		card_icon.size_flags_horizontal = Control.SIZE_SHRINK_END

		%History.add_child(card_icon)
		
func extract_texture_db_from_card_type(card_type):
	#"spell" "unit" "lvlup_spell"  "building" "upgrade" 
	var db
	match card_type:
		"spell":
			db = Base.SPELL_TEXTURES
		"unit":
			db = Base.CREEP_TEXTURES
		"lvlup_spell":
			db = Base.LVLUP_SPELLS_TEXTURES
		"building":
			db = Base.BUILDING_TEXTURES
		"upgrade":
			db = Base.UPGRADE_TEXTURES
		_:
			push_error("unknown card_type in opponent's history")
		
	return db
			
			
	
	
var shown:bool = false
func _on_show_hide_button_pressed():
	if shown == true:
		shown = false
		hide_history()
	else:
		shown = true
		show_history()
		

func hide_history():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self,
			 "position:x", starting_x , animation_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%Show_hide_button, "rotation_degrees", 90, rotation_time)

func show_history():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self,
			 "position:x", starting_x + %TextureRect.size.x , animation_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(%Show_hide_button, "rotation_degrees", -90, rotation_time)
