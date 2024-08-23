extends Card_In_Hand



@export var Scene: PackedScene			#PREVIEW WHEN DRAGGING
@export var PreviewScene: PackedScene 	#PREVIEW WHEN HOVERED OVER


#to prevent multiple previews
var showing = 0


var Unit_Name = "E"
var Unit_Pfp 
var Unit_Ability_texture
var Unit_Ability_cooldown
var Unit_Attack = 1
var Unit_Health = 2
var Unit_Armor = 0
var Card_Cost = 0

#var UNIT = 1
var TYPE = 0
var Identification = 3
var HERO
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
		%AR.modulate = Base.Black_color
	%COST.text = str(Card_Cost)
	%XP.text = str(Card_XP)
	
	if has_ability == false:
		%Ability1.visible = false
	
	new_lane()
	
func new_lane():
	#this has to be called through the objects ready function, rest is prepared in class
	match Base.current_lane:
		1:
			arena = arena1
			abarena = abarena1
			arena_rect = arena_rect1
			abarena_rect = abarena_rect1
			tower_mana = tower_mana1
		2:
			arena = arena2
			abarena = abarena2
			arena_rect = arena_rect2
			abarena_rect = abarena_rect2
			tower_mana = tower_mana2
		3:
			arena = arena3
			abarena = abarena3
			arena_rect = arena_rect3
			abarena_rect = abarena_rect3
			tower_mana = tower_mana3


		


		
func _get_drag_data(_at_position):
	var manacheck = does_player_have_enough_mana(self)
	if manacheck == true:
		var herocheck = arena_rect.is_there_a_hero_check()
		if herocheck == true:
			Base.lock_pass_button()
			#until preview is gone
			var drag_preview = create_preview(Identification)
			set_drag_preview(drag_preview)
			drag_preview.modulate.a = .5
			

			arena_rect.Carrying = 1
			arena.move_roof_to_front()
			if Base.PLAYTEST == 0:
				abarena_rect.Carrying = 1
				abarena.move_roof_to_front()
			
			
			return [TYPE, Identification, self.get_index(), has_ability]
		else: no_hero_to_cast_this(self)
	else: not_enough_mana(self)


func create_preview(ID):
	var preview = Scene.instantiate()
	assign_stats(preview, ID)
	
	

	return preview
	
func assign_stats(preview, ID):
	var DB_slot = CreepsDB.CREEPS_DB[ID]
	preview.Unit_Pfp = Base.CREEP_TEXTURES[ID]
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
	
	preview.has_ability = has_ability
		

		












	





func _on_slacksus_mouse_entered():
	create_card_in_hand_preview(self,Identification)


func _on_slacksus_mouse_exited():
	remove_card_in_hand_preview(self)
