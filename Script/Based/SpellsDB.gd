extends Node


var NAMEPOSITION = 0
var COSTPOSITION = 1
var XPPOSITION = 2
var TARGPOSITION = 3
var BONUSTARGPOSITION = 4
var CROSSLANEPOSITION = 5
var ISPLAYEDONPOSITION = 6








var SPELLS_DB = [
["Annihilate", 6, -4, Enums.Targeting.one_unit, Enums.Targeting.none,false,"Unit"],
["Bread", 4, 2, Enums.Targeting.lane, Enums.Targeting.none,false,"Lane"],
["Dorbystrike", 7, 5, Enums.Targeting.one_unit, Enums.Targeting.none,false,"Unit"],
["Duel",3,6,Enums.Targeting.one_ally, Enums.Targeting.one_enemy, false,"Hero"],
["Morning",7,1, Enums.Targeting.one_unit, Enums.Targeting.none,false,"Unit"],
["Hmmmmm",5,12, Enums.Targeting.lane, Enums.Targeting.none,false,"Lane"],
["My_peak",5,2, Enums.Targeting.one_ally, Enums.Targeting.none,false,"Hero"],
["SummonTwo",3,1, Enums.Targeting.lane, Enums.Targeting.none,false,"Lane"],
["Swap",2,3,Enums.Targeting.one_ally, Enums.Targeting.one_ally, false,"Unit"]
]
# Called when the node enters the scene tree for the first time.

func find_my_id(spell, spell_name):
	return spell[0] == spell_name
	
func unit_targeted_from_here_signal(target, spell_name):
	await target.tower_layer.something_targeted_signal(target,SPELLS_DB[SPELLS_DB.find_custom(find_my_id.bind(spell_name))])

func play_spell_sfx(spell_name:String):
	Base.play_global_sfx("spell", spell_name)

func Dorbystrike(target, _current_player = "", _rpced = false):
	await target.take_damage(5-target.ArmorC)
	
	
func Duel(Caster, Target1, _current_player = "", _sync_data = null, _rpced = false):
	await Duel_effect(Caster, Target1, _current_player, _sync_data, _rpced)
	await unit_targeted_from_here_signal(Caster, "Duel")
	await unit_targeted_from_here_signal(Target1, "Duel")
	

	
var get_into_duel_time:float = 0.8
#needs to be accessed from Duel_vfx
func Duel_effect(caster, target, _current_player = "", _sync_data = null, _rpced = false):
	Base.lock_pass_button()
	await caster.UI_layer_based_animation("Duel")

	var screen_center = Base.get_screen_center()
	var half_of_calced_space = Vector2(0.0, 120)
	var caster_position = screen_center #+ half_of_calced_space
	var target_position = screen_center - Vector2(0.0, Base.CARD_HEIGHT) #- half_of_calced_space
	
	caster.move_z_forward()
	target.move_z_forward()
	caster.dont_flinch()
	target.dont_flinch()
	#var tween = create_tween().set_parallel(true)
	#tween.tween_property(caster,"global_position",caster_position,get_into_duel_time)
	#tween.tween_property(target,"global_position",target_position,get_into_duel_time)
	caster.global_position = caster_position
	target.global_position = target_position
	#await tween.finished
	await get_tree().create_timer(get_into_duel_time).timeout
		
	var attack1 = caster.AttackC - target.ArmorC
	var attack2 = target.AttackC - caster.ArmorC #CURRENT IMPLLLLLLLL
	caster.SMASH(false)
	await target.SMASH(false)
	#await get_tree().create_timer(Base.SMASH_animation_time).timeout

	caster.take_damage(attack2)
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	#Once graveyard for units is added, this should no longer be needed
	#hero_death_Care in CardLayer can manage heroes dying at the "same" time
	await target.take_damage(attack1)
	
	caster.move_z_backwards()
	target.move_z_backwards()
	caster.flinch_again()
	target.flinch_again()
	
	await get_tree().create_timer(caster.MYrena_rect.collide_time).timeout
	while caster.MYrena_rect.colliding != 0:
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
	#better way of awaiting this?
		
	Base.unlock_pass_button()

func SummonTwo(allied_row, _current_player = "", _rpced = false):
	play_spell_sfx("Summon_two")
	if _rpced == false:
		allied_row.spawn_unit(6, 2, null, false, false)
		#allied_row.mass_second_ready()
			
		
func My_peak(target, _current_player = "", _rpced = false):
	Base.lock_pass_button()
	await target.particle_holder_based_animation("My_peak")
	
	target.can_lvlup = false
	
	target.Siege = true
	target.increase_HealthM(5,true)
	target.increase_ArmorM(1,true)
	target.increase_AttackM(5,true)	
	
	if _rpced == false:
		for i in 5:
			Base.Player_heroes[i].Lvlup_xp += 2
	else:
		for i in 5:
			Base.Opponent_heroes[i].Lvlup_xp += 2
		
	await target.XP_panel.update_xp_labels()
	
	Base.unlock_pass_button()
	
func Morning(target, _current_player = "", _rpced = false):
	target.debuff_applied_animation()
	var sound_effect = load("res://Assets/Sounds/SFX/Spells/Morning.mp3")
	target.sfx_base.stream = sound_effect
	target.sfx_base.play()
	
	
	var previous_health = target.HealthC
	target.HealthC = 1
	target.updateS()
	await target.increase_damage_to_be_taken(0)
	if _rpced == false:
		if target.faction == "alpha":
			target.XP_panel.increase_xp(2* (previous_health+1))
			
		
func Annihilate(target, _current_player = "", _rpced = false):
	Base.lock_pass_button()
	await target.particle_holder_based_animation("Annihilate")
	var DAMAGE = 12
	var HP = target.HealthC
	var expected_damage = DAMAGE
	if expected_damage > HP:
		var damage_to_tower = expected_damage - HP
		target.MYrena_rect.MYTower.take_damage(damage_to_tower)
		expected_damage -= damage_to_tower
	await target.take_damage(expected_damage)
	Base.unlock_pass_button()
	
	
func Hmmmmm(_allied_lane, _current_player = "", _rpced = false):
	play_spell_sfx("Hmmmm")
	pass

func Bread(allied_lane, _current_player = "", _rpced = false):
	if _rpced == false:
		await allied_lane.scrollh.draw_cards(2)
		
func Swap(swapped_unit, swapping_unit, _current_player = "", _sync_data = null, _rpced = false):
	await Swap_effect(swapped_unit, swapping_unit, _current_player, _sync_data, _rpced)
	await unit_targeted_from_here_signal(swapped_unit, "Swap")
	await unit_targeted_from_here_signal(swapping_unit, "Swap")
	
func Swap_effect(swapped_unit, swapping_unit, _current_player, _sync_data, _rpced):

	await swapped_unit.annul_my_presence()
	await swapping_unit.annul_my_presence()
	

	
	#var retarget = swapped_unit.targeting
	#swapped_unit.targeting = swapping_unit.targeting
	#swapping_unit.targeting = retarget
	#swap their targeting
	
	#var straiged = swapped_unit.straight_target
	##var sideged = swapped_unit.side_target
	#swapped_unit.straight_target = swapping_unit.straight_target
	##swapped_unit.side_target = swapping_unit.side_target
	#swapping_unit.straight_target = straiged
	#swapping_unit.side_target = sideged
	
	var id_1 = swapped_unit.get_index()
	var id_2 = swapping_unit.get_index()
	var common_parent = swapped_unit.get_parent()
	
	var sound_effect = load("res://Assets/Sounds/SFX/Movement.mp3")
	swapped_unit.sfx_base.stream = sound_effect
	swapped_unit.sfx_base.play()
	
	
	
	
	common_parent.move_child(swapped_unit,id_2)
	common_parent.move_child(swapping_unit,id_1)
	await common_parent.collide_units()
	
	swapped_unit.redirect_damage_to_me_again()
	swapping_unit.redirect_damage_to_me_again()
	swapped_unit.curve_straight(false)
	swapping_unit.curve_straight(false)
	
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	await swapped_unit.tower_layer.unit_order_changed_signal(swapped_unit.my_lane)
	
	
var Dorbystrike_description = "Deal 8 damage to a unit"
var Duel_description = "Target an allied hero and an enemy unit. 
The two units strike each other"
var SummonTwo_description = "Summon two zombies"
var My_peak_description = "Lvlupping cost 2XP more. Modify allied hero: I can't lvlup 
but I get: +5/5, +1 armor and [SIEGE]"
var Morning_description = "set unit's Health to 1, if it was an ally, 
gain XP equal to twice how much the health has changed"
var Annihilate_description = "Deal 12 magical damage to unit, excess damage is dealt to its tower"
var Hmmmmm_description = " "
var Bread_description = "Draw 2"
var Swap_description = "Select two allies and swap their position"
