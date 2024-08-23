extends Control

@onready var player_HP = $"../../../UI_layer/Player_HP"
@onready var game_over = $"../../../UI_layer/Game_over"
@onready var player_mana = $"../../../UI_layer/Player_mana_display"
@onready var buildings = $Buildings

var HealthM = 12
var HealthC = 12
var ArmorC = 0
var TYPE = 11
var my_lane
#given by tower layer during its ready
#it works: 2.3. 2024

var damage_to_be_taken = 0


func _ready():
	%TOWER_HP.text = str(HealthC) + "/" + str(HealthM)
	%DMG_TBT.text = str(damage_to_be_taken)

	
#	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
#	print("my lane is:" +str(my_lane))


func Update_Tower_Health():
	if HealthC <= 0:
		new_tower_rises()	
	%TOWER_HP.text = str(HealthC) + "/" + str(HealthM)
	visualise_health_loss()
	



func take_damage(Damage_to_tower):
	
	
	if Damage_to_tower > HealthC:
		if Damage_to_tower > HealthC + HealthM +1:
			Damage_to_tower -= HealthC
			HealthC = 0
			Update_Tower_Health() 

			if Damage_to_tower > HealthC:
				if Damage_to_tower > HealthC + HealthM +1:
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
	
func new_tower_rises():
	HealthM+= 1  
	if HealthM> Base.LAST_TOWER_HP:
		#set to 23 atm
		match name:
			"TowerA":
				game_over.YOU_LOSE()
			"TowerB":
				game_over.YOU_WIN()      
	else:       
		HealthC = HealthM
		player_HP.tower_destroyed(name)
	
	
	

func take_combat_damage():
	take_damage(damage_to_be_taken)

func Im_attacked_only_by(attacker, _siege):
	var dmg = attacker.AttackC
	attacker.damage_used_up_1 = dmg
	increase_damage_to_be_taken(dmg - ArmorC)
#	printerr("increasing tower dtbt by: " +str(dmg))
		
func Im_straight_attacked_by(attacker):		
	var dmg = ceil(attacker.AttackC / 2.0)
	attacker.damage_used_up_1 = dmg
	increase_damage_to_be_taken(dmg - ArmorC)  
		
func Im_no_longer_attacked_only_by(attacker, _siege = false, power = 1):
	#power because of curving via annuling update	
	var dmg = attacker.damage_used_up_1
	if power == 1:
		attacker.damage_used_up_1 = 0
	increase_damage_to_be_taken(-dmg + ArmorC) 
	
#	printerr("decreasing tower dtbt by: " +str(dmg))

		
func Im_no_longer_straight_attacked_by(attacker, _siege = false, power = 1):
	var dmg = attacker.damage_used_up_1
	if power == 1:
		attacker.damage_used_up_1 = 0
	increase_damage_to_be_taken(-dmg + ArmorC) 


func increase_damage_to_be_taken(amount):
	damage_to_be_taken += amount
	%DMG_TBT.text = str(damage_to_be_taken)
#	push_error("T increasing dmg tbt by: " +str(amount) +" " + str( damage_to_be_taken))
	if Base.Combat_phase == 0:
		visualise_health_loss()


func visualise_health_loss():
	if Base.current_lane == my_lane:
		var healthloss = 0
		if damage_to_be_taken >= HealthC:
			healthloss += 1
			if damage_to_be_taken >= HealthC+HealthM+1:
				healthloss +=1
				if  damage_to_be_taken >= HealthC+(2*HealthM)+3:
					#thats just formula for towerHP growth
					healthloss +=1

		player_HP.new_damage_to_be_taken(healthloss, name)
