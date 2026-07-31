extends Card_preview



var Unit_Ability_texture
var Unit_Ability_cooldown
var Unit_Attack = 1
var Unit_Health = 2
var Unit_Armor = 0

var has_ability = false




func local_ready():
	TYPE = "unit"
	%Attack_label.text = str(Unit_Attack)
	%HP_label.text = str(Unit_Health)
	%Armor_label.text = str(Unit_Armor)
	%Ability1.texture = Unit_Ability_texture
	if Unit_Armor != 0:
		%Armor_label.visible = 1
	if has_ability == false:
		%Ability1.visible = false
	


func _on_tree_exited():
	if previewed_card:
		previewed_card.visible = true
	arena_rect.Carrying = 0
	abarena_rect.Carrying = 0
	#requires signal turned on
	card_layer.card_preview_is_no_longer_being_dragged()
	arena.move_roof_back()
	arena.uneclipse_abarena()
	abarena.move_roof_back()
	Base.unlock_pass_button()
	#because we locked it once we started dragging the preview
