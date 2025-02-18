extends TextureRect

@export var spell_preview: PackedScene
@export var lvlup_spell_preview: PackedScene
@export var unit_preview: PackedScene
@export var building_preview: PackedScene
@export var upgrade_preview: PackedScene

@onready var UI_layer = 		$"../../../../.."
@onready var action_history = 	$"../../../.."



var card_type:String = "upgrade"
	#"spell" "lvlup_spell" "unit" "building" "upgrade" 
var card_ID: int = 0

var my_preview:Node


var preview_position = Vector2(220,-100)
var preview_scale = Vector2(1.2,1.2)



#func _ready():
#	pass 

func _on_mouse_entered():
	var creating_function = "create_" + card_type +"_preview"
	my_preview = call(creating_function)
	my_preview.position = get_global_transform_with_canvas().origin + preview_position
	my_preview.scale = preview_scale
	UI_layer.add_child(my_preview)

func _on_mouse_exited():
	remove_card_in_hand_preview()




func remove_card_in_hand_preview():
	if my_preview != null:
		my_preview.queue_free()
		my_preview = null




func create_spell_preview():
	var preview = spell_preview.instantiate()
	assign_spell_stats(preview,card_ID)
#	preview.position = UI_layer.position
	
	return preview

func assign_spell_stats(preview, ID):
	preview.Card_name = SpellsDB.SPELLS_DB[ID][SpellsDB.NAMEPOSITION]
	preview.Card_pfp = Base.SPELL_TEXTURES[ID]
	preview.Card_Cost = SpellsDB.SPELLS_DB[ID][SpellsDB.COSTPOSITION]
	preview.Card_XP = SpellsDB.SPELLS_DB[ID][SpellsDB.XPPOSITION]
	preview.Targets = SpellsDB.SPELLS_DB[ID][SpellsDB.TARGPOSITION]
	preview.cross_lane = SpellsDB.SPELLS_DB[ID][SpellsDB.CROSSLANEPOSITION]
	preview.Identification = ID	


func create_unit_preview():
	var preview = unit_preview.instantiate()
	assign_unit_stats(preview, card_ID)

	return preview
	
	
func assign_unit_stats(preview, ID):
	var DB_slot = CreepsDB.CREEPS_DB[ID]
	preview.Card_pfp = Base.CREEP_TEXTURES[ID]
	preview.Unit_Name = DB_slot[CreepsDB.NAMEPOSITION]
	preview.Unit_Attack = DB_slot[CreepsDB.ATTACKPOSITION]
	preview.Unit_Health = DB_slot[CreepsDB.HEALTHPOSITION]
	preview.Unit_Armor = DB_slot[CreepsDB.ARMORPOSITION]
	preview.Card_Cost = DB_slot[CreepsDB.COSTPOSITION]
	preview.Card_XP = DB_slot[CreepsDB.XPPOSITION]
	preview.Identification = ID
	
	if DB_slot[CreepsDB.ABILITYPOSITION] == true:
		preview.Unit_Ability_texture = Base.CREEP_ABILITY_TEXTURES[ID]
		preview.Unit_Ability_cooldown = AbilitiesDB.CREEP_ABILITIES_DB[ID][AbilitiesDB.COOLDOWNPOSITION]
		preview.has_ability = true
	else:
		preview.has_ability = false


func create_lvlup_spell_preview():
	var preview = lvlup_spell_preview.instantiate()
	assign_lvlup_spell_stats(preview,card_ID)
	
	return preview
	

func assign_lvlup_spell_stats(preview, ID):
	preview.Card_name = LvlupDB.LVLUPS_DB[ID][LvlupDB.NAMEPOSITION]
	preview.Card_pfp = Base.LVLUP_CARDS_TEXTURES[ID]
	preview.Card_Cost = LvlupDB.LVLUPS_DB[ID][LvlupDB.COSTPOSITION]
	preview.Card_XP = 0
	preview.Targets = LvlupDB.LVLUPS_DB[ID][LvlupDB.TARGPOSITION]
	preview.cross_lane = LvlupDB.LVLUPS_DB[ID][LvlupDB.CROSSLANEPOSITION]
	preview.Identification = ID
	
func create_building_preview():
	var preview = building_preview.instantiate()
	assign_building_stats(preview,card_ID)
	
	return preview

	


func assign_building_stats(preview, ID):
	preview.Card_name = BuildDB.BUILD_DB[ID][BuildDB.NAMEPOSITION]
	preview.Build_Pfp = Base.BUILDING_TEXTURES[ID]
	preview.Card_Cost = BuildDB.BUILD_DB[ID][BuildDB.COSTPOSITION]
	preview.Card_XP = BuildDB.BUILD_DB[ID][BuildDB.XPPOSITION]

func create_upgrade_preview():
	var preview = upgrade_preview.instantiate()
	assign_upgrade_stats(preview,card_ID)

	return preview
	
func assign_upgrade_stats(preview, ID):
	preview.Item_Name = ItemsDB.ITEMS_DB[ID][ItemsDB.NAMEPOSITION]
	preview.ITEMM = ItemsDB.ITEMS_DB[ID][ItemsDB.ITEMMPOSITION]
	preview.Item_Pfp = Base.ITEM_TEXTURES[ID]
#	preview.Item_Stat = ItemsDB.ITEMS_DB[ID][ItemsDB.STATPOSITION]
	preview.Card_Cost = ItemsDB.ITEMS_DB[ID][ItemsDB.COSTPOSITION]
	preview.Item_cooldown = ItemsDB.ITEMS_DB[ID][ItemsDB.COOLDOWNPOSITION]
	preview.Identification = ID

