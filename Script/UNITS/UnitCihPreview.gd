extends empty_preview

#currently used when dragging heroes during deployment and history
#the emptiness is useful
#past copy of UnitCIHPreview

var Unit_Ability_texture
var Unit_Ability_cooldown
var Unit_Attack = 1
var Unit_Health = 2
var Unit_Armor = 0
var has_ability = false
#var actually_exiting = 1
var HERO = false

func local_ready():
	TYPE = "unit"
	%Attack_label.text = str(Unit_Attack)
	%HP_label.text = str(Unit_Health)
	%Armor_label.text = str(Unit_Armor)
	var loaded_script = load("res://Script/Creep_abilities_list/" + str(CreepsDB.CREEPS_DB[Identification][CreepsDB.NAMEPOSITION]) + "_passive.gd")
	var script_instance
	if loaded_script != null:
		script_instance = loaded_script.new()
		%Description_label.text = script_instance.description
	elif loaded_script == null:
		%Description_label.text = "I'm lowkey useless"
	
	if Unit_Armor != 0:
		%Armor_label.visible = true
	
	
	if has_ability == false:
		%Ability1.visible = false
	else: 
		%Ability1.texture = Unit_Ability_texture
