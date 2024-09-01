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
["My_peak",5,5, Enums.Targeting.one_ally, Enums.Targeting.none,false,"Hero"],
["SummonTwo",3,1, Enums.Targeting.lane, Enums.Targeting.none,false,"Lane"],
["Swap",2,3,Enums.Targeting.one_ally, Enums.Targeting.one_ally, false,"Unit"]
]
# Called when the node enters the scene tree for the first time.

func Dorbystrike(target):
	await target.take_damage(5-target.ArmorC)
	
	
func Duel(Caster, Target1):
	var attack1 = Caster.AttackC - Target1.ArmorC
	var attack2 = Target1.AttackC - Caster.ArmorC #CURRENT IMPLLLLLLLL

	Caster.take_damage(attack2)
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	#Once graveyard for units is added, this should no longer be needed
	#hero_death_Care in CardLayer can manage heroes dying at the "same" time
	await Target1.take_damage(attack1)

func SummonTwo(allied_row):
	for i in 2:
		await allied_row.spawn_unit(6)
		
func My_peak(target):
	target.can_lvlup = false
	for i in 5:
		Base.Player_heroes[i].Lvlup_xp += 2
	
	target.increase_HealthM(5,1)
	target.increase_ArmorM(1,1)
	target.Siege = true
	target.increase_AttackM(5,1)	
	
	await target.XP_panel.update_xp_labels()
	
func Morning(target):
	var previous_health = target.HealthC
	target.HealthC = -1
	target.updateS()
	await target.increase_damage_to_be_taken(0)
	if target.faction == "alpha":
		target.XP_panel.increase_xp(2* (previous_health+1))
		
func Annihilate(target):
	var DAMAGE = 12
	var HP = target.HealthC
	var expected_damage = DAMAGE
	if expected_damage > HP:
		var damage_to_tower = expected_damage - HP
		target.MYrena_rect.MYTower.take_damage(damage_to_tower)
		expected_damage -= damage_to_tower
	await target.take_damage(expected_damage)
	
func Hmmmmm(_allied_lane):
	pass

func Bread(allied_lane):
	await allied_lane.scrollh.draw_cards(2)
		
func Swap(swapped_unit, swapping_unit):
	swapped_unit.annul_my_presence()
	swapping_unit.annul_my_presence()
	

	
	var retarged = swapped_unit.targeting
	swapped_unit.targeting = swapping_unit.targeting
	swapping_unit.targeting = retarged
	#swap their targeting
	
	var straiged = swapped_unit.straight_target
	var sideged = swapped_unit.side_target
	swapped_unit.straight_target = swapping_unit.straight_target
	swapped_unit.side_target = swapping_unit.side_target
	swapping_unit.straight_target = straiged
	swapping_unit.side_target = sideged
	
	var id_1 = swapped_unit.get_index()
	var id_2 = swapping_unit.get_index()
	var common_parent = swapped_unit.get_parent()
	
	common_parent.move_child(swapped_unit,id_2)
	common_parent.move_child(swapping_unit,id_1)
	common_parent.collide_units()
	
	swapped_unit.redirect_damage_to_me_again()
	swapping_unit.redirect_damage_to_me_again()
	swapped_unit.curve_rng()
	swapping_unit.curve_rng()
	
	await get_tree().create_timer(Base.FAKE_DELTA).timeout 
	await swapped_unit.tower_layer.unit_order_changed_signal(swapped_unit.my_lane)
	
var Dorbystrike_description = "Deal 8 damage to a unit"
var Duel_description = "Target an allied hero and an enemy unit. 
The two units strike each other"
var SummonTwo_description = "Summon two zombies"
var My_peak_description = "Lvlupping cost 2XP more. Modify allied hero: I can't lvlup 
but I get: +5/5, +1 armor and [SIEGE]"
var Morning_description = "set unit's Health to -1, if it was an ally, 
gain XP equal to twice how much the health has changed"
var Annihilate_description = "Deal 12 magical damage to unit, excess damage is dealt to its tower"
var Hmmmmm_description = " "
var Bread_description = "Draw 2"
var Swap_description = "Select two allies and swap their position"
