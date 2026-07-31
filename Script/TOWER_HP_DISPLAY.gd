extends Control

@export var tower_damage_visual: PackedScene

@onready var player_HP = $"../../../UI_layer/Player_HP"
@onready var game_over = $"../../../UI_layer/Game_over"
@onready var effect_layer = $"../../../Effect_layer"
@onready var player_mana = $"../../../UI_layer/Player_mana_display"
@onready var opponent_player_mana = $"../../../UI_layer/Opponent_info/Opponent_mana"
@onready var buildings = $Buildings
@onready var current_mana = %Current_mana
@onready var max_mana = %Max_mana
@onready var tower_png: TextureRect = %Tower_png
@onready var crumbling_sfx: AudioStreamPlayer2D = %Crumbling_sfx
@onready var fortification_shield: TextureRect = %Fortification_shield

@onready var plating_bar_red_green: TextureProgressBar = $Plating_bar_red_green
@onready var plating_bar_black: TextureProgressBar = $Plating_bar_red_green/Plating_bar_black


var HealthM:int
var HealthC:int
var ArmorC:int = 0
var TYPE:String = "tower" #11
var my_lane:int
#given by tower layer during its ready
#it works: 2.3. 2024

var first_tower_healthM:int  = 10
var second_tower_healthM:int = 20
var third_tower_healthM:int  = 60

var plating_current:int = 5

var breached:bool = false
	#after first five plating are destroyed
var obliterated:bool = false
	#after surviving destruction of second tower
var fortified:bool = false
	#after tower is destroyed, the next is fortified 
		#until end of tuesday, or end of round, whichever is first
	
var first_plating_damage:int = 5
var second_plating_damage:int = 10

var damage_to_be_taken:int = 0

var visual_center:Vector2
	#global position of the centre of tower_png
		#used for animations
var crumbling_animation_length = 2

func _ready():
	HealthM = first_tower_healthM
	HealthC = first_tower_healthM
	
	%TOWER_HP.text = str(HealthC) + "/" + str(HealthM)
	%DMG_TBT.text = str(damage_to_be_taken)

	visual_center = tower_png.global_position + tower_png.size / Vector2(2.0,2.0)
#	await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
#	print("my lane is:" +str(my_lane))


func update_tower_health():
	var hit_depleted_plating:bool = false
	if HealthC <= 0:
		hit_depleted_plating = await lose_tower_plating()	
	%TOWER_HP.text = str(HealthC) + "/" + str(HealthM)
	visualise_health_loss()
	
	return hit_depleted_plating
	



#func take_damage_legacy(Damage_to_tower):
	#var plating_depleted:bool = false
	#
	#
	#if Damage_to_tower > HealthC:
		#if Damage_to_tower > HealthC + get_next_healthM(1):
			#Damage_to_tower -= HealthC
			#HealthC = 0
			#plating_depleted = update_tower_health() 
			#if Damage_to_tower > HealthC:
				#if Damage_to_tower > HealthC + get_next_healthM(1):
					#Damage_to_tower -= HealthC
					#HealthC = 0
					#plating_depleted = update_tower_health()
					#
					#HealthC -= Damage_to_tower
				#else:
					#var Overkill_damage = Damage_to_tower - HealthC
					#HealthC = 0
					#plating_depleted = update_tower_health()
					#HealthC -= Overkill_damage
			#else:
				#HealthC -= Damage_to_tower
		#else:
			#var Overkill_damage = Damage_to_tower - HealthC
			#HealthC = 0
			#plating_depleted = update_tower_health()
			#HealthC -= Overkill_damage
	#else:
		#HealthC -= Damage_to_tower
		#
	#update_tower_health() 

	
func take_damage(damage_to_tower, full:bool = true, platings_destroyed:int = 0):
	if fortified:
		return false
		
	if full and damage_to_tower != 0:
		health_change_animation(damage_to_tower)
		
	var plating_was_depleted:bool = false
	
	if damage_to_tower > HealthC:
		damage_to_tower -= HealthC
		HealthC = 0
		plating_was_depleted = await update_tower_health()
		if plating_was_depleted:
			return true
			#whether tower was destroyed, used for awaiting
		elif damage_to_tower > 0 and platings_destroyed < 2:
			take_damage(damage_to_tower,false, platings_destroyed +1)
	else:
		HealthC -= damage_to_tower
		update_tower_health()
	return false
	
func tower_crumbling_animation():
	crumbling_sfx.play()
	var second_tower_texture = load("uid://brccj8cn87r25")
	var tween = create_tween()
	tween.tween_property(tower_png, "modulate", Color(0.7,0.0,0.0), crumbling_animation_length)
	await tween.finished
	tower_png.modulate = Color(1.0,1.0,1.0)
	tower_png.texture = second_tower_texture
	activate_fortification()
	increase_damage_to_be_taken(0)
	return 0
	
func activate_fortification():
	fortified = true
	fortification_shield.visible = true
	
func remove_fortifications():
	fortified = false
	fortification_shield.visible = false
	
var health_change_animation_count:int = 0	

func health_change_animation(health_change_value:int):	
	var another = tower_damage_visual.instantiate()
	another.global_position = tower_png.global_position
	another.health_change_value = health_change_value
	another.simultaneous_position = health_change_animation_count
	health_change_animation_count += 1
	
	effect_layer.add_child(another)
	await get_tree().create_timer(another.tween_duration).timeout
	health_change_animation_count -= 1
	
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
	
	
func lose_tower_plating():
	var hit_depleted_plating:bool = false
	plating_current -= 1
	plating_bar_black.value += 1
	player_HP.tower_destroyed(name, 1)
	if plating_current == 0:
		await tower_crumbling_animation()
		plating_depleted()
		hit_depleted_plating = true
	
	
	HealthC = HealthM
	return hit_depleted_plating
	
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
	if fortified: 
		damage_to_be_taken = 0
	else:
		damage_to_be_taken += amount
	%DMG_TBT.text = str(damage_to_be_taken)
	#push_error("T increasing dmg tbt by: " +str(amount) +" " + str( damage_to_be_taken))
	if Base.Combat_phase == false:
		visualise_health_loss()


func visualise_health_loss():
	var healthloss = 0
	if damage_to_be_taken >= HealthC:
		healthloss += 1
		if plating_current - healthloss != 0:
			if damage_to_be_taken >= HealthC+ get_next_healthM(1):
				healthloss +=1
				if plating_current - healthloss != 0:
					if  damage_to_be_taken >= HealthC + get_next_healthM(2):
						#thats just formula for towerHP growth
						healthloss +=1
	visualise_plating_loss(healthloss) 	

	if Base.current_lane == my_lane:
		healthloss += include_plating_depletion_in_health_loss_visualisation(healthloss)
		player_HP.new_damage_to_be_taken(healthloss, name)
		

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
			

func before_prep_phase():
	#unit spawning during deployment causes double ready
		#and prep is cleaning anyway
	increase_damage_to_be_taken(-damage_to_be_taken)
	
	
func extract_children_into_array():
	#used when trigging passives in tower_layer
	var result_array = []
	var population = buildings.get_child_count()
	for i in population:
		result_array.append(buildings.get_child(i))
	return result_array
