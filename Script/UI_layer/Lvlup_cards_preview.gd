extends Control

@export var lvlup_spell_scene: PackedScene 			#PREVIEW WHEN DRAGGING



@onready var h_0: TextureRect = $HBoxContainer/H0
@onready var h_1: TextureRect = $HBoxContainer/H1
@onready var h_2: TextureRect = $HBoxContainer/H2
@onready var h_3: TextureRect = $HBoxContainer/H3
@onready var h_4: TextureRect = $HBoxContainer/H4

#@onready var lc_0: Control = $HBoxContainer/H0/LC0
#@onready var lc_1: Control = $HBoxContainer/H1/LC1
#@onready var lc_2: Control = $HBoxContainer/H2/LC2
#@onready var lc_3: Control = $HBoxContainer/H3/LC3
#@onready var lc_4: Control = $HBoxContainer/H4/LC4


var hero_pfps
var lvlup_cards

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	hero_pfps = [h_0, h_1, h_2, h_3, h_4]
	#lvlup_cards = [lc_0, lc_1, lc_2, lc_3, lc_4]
	
	update_pfps()
	update_lvlup_cards()
	


func update_pfps():
		for i in 5:
			hero_pfps[i].texture = Base.Player_heroes[i].Unit_Icon
			
func update_lvlup_cards():
	for i in 5:
		var another = create_preview(Base.HeroDeck[i])
		another.position = Vector2(75.0, 240.0)
		hero_pfps[i].add_child(another)
			
func create_preview(ID):
	var preview = lvlup_spell_scene.instantiate()
	assign_stats(preview,ID)
	
	return preview
			
func assign_stats(preview, ID):
	preview.card_DB = LvlupDB
	preview.card_name = LvlupDB.LVLUPS_DB[ID][LvlupDB.NAMEPOSITION]
	preview.card_art = Base.LVLUP_SPELLS_TEXTURES[ID]
	preview.card_cost = LvlupDB.LVLUPS_DB[ID][LvlupDB.COSTPOSITION]
	preview.card_xp = 0 
	#preview.Targets = LvlupDB.LVLUPS_DB[ID][LvlupDB.TARGPOSITION]
	#preview.cross_lane = LvlupDB.LVLUPS_DB[ID][LvlupDB.CROSSLANEPOSITION]
	#preview.Identification = ID
			
func show_or_hide():
	if visible: 
		visible = false
	else: 
		visible = true
			
			
			
			
