extends Card_preview



var Unit_Name = "E"
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

var Card_XP



func _ready():
	%NAME.text = Unit_Name
	%ATK.text = str(Unit_Attack)
	%HP.text = str(Unit_Health)
	%AR.text = str(Unit_Armor)
	%HERO_JPEG.texture = Unit_Pfp
	%Ability1.texture = Unit_Ability_texture
	if Unit_Armor != 0:
		%AR.visible = 1
	%COST.text = str(Card_Cost)
	if Card_XP == 0:
		%XP.visible = false
	else:
		%XP.text = str(Card_XP)
	if has_ability == false:
		%Ability1.visible = false
	
	new_lane()
	
func new_lane():
	match Base.current_lane:
		1:
			arena = arena1
			abarena = abarena1
			arena_rect = arena_rect1
			abarena_rect = abarena_rect1
		2:
			arena = arena2
			abarena = abarena2
			arena_rect = arena_rect2
			abarena_rect = abarena_rect2

		3:
			arena = arena3
			abarena = abarena3
			arena_rect = arena_rect3
			abarena_rect = abarena_rect3




func _on_tree_exited():
	print("Unit_preview exiting tree")
#	if actually_exiting == 1:
	arena_rect.Carrying = 0
	abarena_rect.Carrying = 0
	#requires signal turned on
	arena.move_roof_back()
	abarena.move_roof_back()
	Base.unlock_pass_button()
	#because we locked it once we started dragging the preview

