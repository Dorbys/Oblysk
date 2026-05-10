extends Control

@onready var player_HP = $"../../../UI_layer/Player_HP"
@onready var game_over = $"../../../UI_layer/Game_over"
@onready var player_mana = $"../../../UI_layer/Player_mana_display"
@onready var opponent_player_mana = $"../../../UI_layer/Opponent_info/Opponent_mana"
@onready var buildings = $Buildings
@onready var current_mana = %Current_mana
@onready var max_mana = %Max_mana

@onready var plating_bar_red_green: TextureProgressBar = $Plating_bar_red_green
@onready var plating_bar_black: TextureProgressBar = $Plating_bar_red_green/Plating_bar_black


var HealthM
var HealthC
var ArmorC = 0
var TYPE = "tower" #11
var my_lane
#given by tower layer during its ready
#it works: 2.3. 2024

var first_tower_healthM  = 10
var second_tower_healthM = 20
var third_tower_healthM  = 60

var plating_current = 5

var breached = false
	#after first five plating are destroyed
var obliterated = false
	#after surviving destruction of second tower
	
var first_plating_damage = 5
var second_plating_damage = 10

var damage_to_be_taken = 0


func _ready():
	HealthM = first_tower_healthM
	HealthC = first_tower_healthM
	
	%TOWER_HP.text = str(HealthC) + "/" + str(HealthM)
	%DMG_TBT.text = str(damage_to_be_taken)

	
#	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
#	print("my lane is:" +str(my_lane))


func Update_Tower_Health():
	if HealthC <= 0:
		lose_tower_plating()	
	%TOWER_HP.text = str(HealthC) + "/" + str(HealthM)
	visualise_health_loss()
	



func take_damage(Damage_to_tower):
	
	
	
	if Damage_to_tower > HealthC:
		if Damage_to_tower > HealthC + get_next_healthM(1):
			Damage_to_tower -= HealthC
			HealthC = 0
			Update_Tower_Health() 
			if Damage_to_tower > HealthC:
				if Damage_to_tower > HealthC + get_next_healthM(1):
					Damage_to_tower -= HealthC
					HealthC = 0
					Update_Tower_Health()
					
					HealthC -= Damage_to_tower
				else:
					var Overkill_damage = Damage_to_tower - HealthC
					HealthC = 0
					Update_Tower_Health()
					HealthC -= Overkill_damage
			else:
				HealthC -= Damage_to_tower
		else:
			var Overkill_damage = Damage_to_tower - HealthC
			HealthC = 0
			Update_Tower_Health()
			HealthC -= Overkill_damage
	else:
		HealthC -= Damage_to_tower
		
	Update_Tower_Health() 
	
func lose_tower_plating():
	plating_current -= 1
	plating_bar_black.value += 1
	player_HP.tower_destroyed(name, 1)
	if plating_current == 0:
		plating_depleted()
	
	
	HealthC = HealthM
	
func plating_depleted():
	if obliterated:
		player_HP.tower_destroyed(name, third_tower_healthM)
		plating_current = 1
	elif breached:
		player_HP.tower_destroyed(name, second_plating_damage)
		HealthM = third_tower_healthM
		plating_current = 5
		obliterated = true
	else:
		player_HP.tower_destroyed(name, first_plating_damage)
		HealthM = second_tower_healthM
		plating_bar_black.value = 0
		plating_current = 5
		breached = true
			

func take_combat_damage():
	take_damage(damage_to_be_taken)

func Im_attacked_only_by(attacker, _siege):
	var dmg = attacker.AttackC
	#attacker.damage_used_up_1 = dmg
	increase_damage_to_be_taken(dmg - ArmorC)
		
#func Im_straight_attacked_by(attacker):		
	#var dmg = ceil(attacker.AttackC / 2.0)
	#attacker.damage_used_up_1 = dmg
	#increase_damage_to_be_taken(dmg - ArmorC)  
		
func Im_no_longer_attacked_only_by(attacker, _siege = false): #, power = 1
	#power because of curving via annuling update	
	#var dmg = attacker.damage_used_up_1
	#push_error("removing dmg to tower of " +attacker.Unit_Name + " dmg: " +str(attacker.AttackC))
	var dmg = attacker.AttackC
	#if power == 1:
		#attacker.damage_used_up_1 = 0
	increase_damage_to_be_taken(-dmg + ArmorC) 
	

		
#func Im_no_longer_straight_attacked_by(attacker, _siege = false, power = 1):
	#var dmg = attacker.damage_used_up_1
	#if power == 1:
		#attacker.damage_used_up_1 = 0
	#increase_damage_to_be_taken(-dmg + ArmorC) 


func increase_damage_to_be_taken(amount):
	damage_to_be_taken += amount
	%DMG_TBT.text = str(damage_to_be_taken)
	#push_error("T increasing dmg tbt by: " +str(amount) +" " + str( damage_to_be_taken))
	if Base.Combat_phase == 0:
		visualise_health_loss()


func visualise_health_loss():
	if Base.current_lane == my_lane:
		var healthloss = 0
		if damage_to_be_taken >= HealthC:
			healthloss += 1
			if damage_to_be_taken >= HealthC+ get_next_healthM(1):
				healthloss +=1
				if  damage_to_be_taken >= HealthC + get_next_healthM(2):
					#thats just formula for towerHP growth
					healthloss +=1
		
		healthloss += include_plating_depletion_in_health_loss_visualisation(healthloss)
		player_HP.new_damage_to_be_taken(healthloss, name)
		visualise_plating_loss(healthloss)

func visualise_plating_loss(amount):
	plating_bar_red_green.value = plating_current - amount 
	
func include_plating_depletion_in_health_loss_visualisation(current_healthloss):
	#visualise doesn't account for 5 / 10 / 60 dmg from depletion
	if plating_current - current_healthloss < 1:
		if obliterated:
			return third_tower_healthM
		elif breached:
			return second_plating_damage
		else:
			return first_plating_damage
			
	else:
		return 0
			
func get_next_healthM(depth, buildup = 0, plating_decreased = 0):
	if depth == 0:
		return buildup
	#var plating_decreased = 0
	#used for calculation when multiple platings are being damaged
	
	plating_decreased += 1
	if breached:
		if plating_current - plating_decreased> 0:
			buildup += second_tower_healthM
			return get_next_healthM(depth -1, buildup, plating_decreased)
		else:
			buildup += third_tower_healthM
			return get_next_healthM(depth -1, buildup, plating_decreased)
	else:
		if plating_current - plating_decreased> 0:
			buildup += first_tower_healthM
			return get_next_healthM(depth -1, buildup, plating_decreased)
		else:
			buildup += second_tower_healthM
			return get_next_healthM(depth -1, buildup, plating_decreased)
