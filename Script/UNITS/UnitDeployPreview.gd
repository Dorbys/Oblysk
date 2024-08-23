extends Control

#currently only used when showing units that are to be deployed
#the emptiness is useful
#past copy of UnitCIHPreview

var Unit_Name = "AlphaCreep"
var Unit_Pfp 
var Unit_Ability_texture
var Unit_Ability_cooldown
var Unit_Attack = 1
var Unit_Health = 2
var Unit_Armor = 0
var Identification = 3
var Card_Cost = 0
#var UNIT = 1
#var SPELL = 0
var TYPE = 0
var has_ability = false
#var actually_exiting = 1
var HERO = 0
var Card_XP

func _ready():
	%NAME.text = Unit_Name
	%ATK.text = str(Unit_Attack)
	%HP.text = str(Unit_Health)
	%AR.text = str(Unit_Armor)
	%HERO_JPEG.texture = Unit_Pfp

	
	if Unit_Armor != 0:
		%AR.visible = true
	if Card_Cost == 0:
		%COST.visible = false
	else:
		%COST.text = str(Card_Cost)
	
	if Card_XP == 0:
		%XP.visible = false
	else:
		%XP.text = str(Card_XP)
	
	if has_ability == false:
		%Ability1.visible = false
	else: 
		%Ability1.texture = Unit_Ability_texture







