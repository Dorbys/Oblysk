extends Control
@onready var Beta = $Beta_pfp/Beta_player_HP
@onready var Alpha = $Alpha_pfp/Alpha_player_HP
@onready var game_over = $"../Game_over"


var AlphaHP = 20
var BetaHP = 20
var HP_array = [AlphaHP, BetaHP]


func _ready():
	Alpha.modulate = Base.Green_color
	Beta.modulate = Base.Green_color
	
	
	
func tower_destroyed(which_one):
	if which_one == "TowerA":
		decrease_alpha_players_HP(1)
	elif which_one == "TowerB":
		decrease_beta_players_HP(1)

func decrease_alpha_players_HP(amount):
	await decrease_players_hp(Alpha, 0, amount)
	if HP_array[0] <= 0: game_over.YOU_LOSE()
	
func decrease_beta_players_HP(amount):
	await decrease_players_hp(Beta, 1, amount)
	if HP_array[1] <= 0: game_over.YOU_WIN()
	
func decrease_players_hp(HP_label, which_hp, amount):
		HP_array[which_hp] -= amount
		if HP_array[which_hp] < 12:
			if HP_array[which_hp] < 6:
				HP_label.modulate = Base.Red_color
			else:
				HP_label.modulate = Base.Orange_color
		HP_label.text = str(HP_array[which_hp])

		
func new_damage_to_be_taken(healthloss, where):
	var target
	if where == "TowerA":
		target = %Alpha_dmg
	elif where == "TowerB":
		target = %Beta_dmg
	else:
		push_error("tower has given playerHP unkown name")
		
	if healthloss == 0:
		target.visible = false
	else:
		target.text = str(healthloss)
		target.visible = true
			
@rpc("any_peer" , "call_remote", "reliable")
func set_opponent_name(given_name):
	$Beta_pfp/Beta_name.text = given_name
		
func set_my_name(given_name):
	$Alpha_pfp/Alpha_name.text = given_name
