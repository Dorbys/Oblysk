extends Label

@onready var tower = $"../.."
@onready var opponent_tower = $"../../../TowerB"

var current_mana

func _ready():
	if Base.PLAYTEST == 1:
		%Max_mana.max_mana = 3
	current_mana = %Max_mana.max_mana
	#so that mana begins on the same as max mana
	update_my_text()
	
func spend_mana(amount):
	current_mana -= amount
	if current_mana <0:
		if tower.name == "TowerA":
			tower.player_mana.spend_mana(abs(current_mana))
		else: #tower.name = "TowerB"
			tower.opponent_player_mana.spend_mana(abs(current_mana))
		current_mana = 0
	if Lobby.MULTIPLAYER == true and tower.name != "TowerB": 
									# cuz both towers share the same script
		rpc_id(Lobby.opponent_peer_id,"mirror_my_mana_change", amount)
	update_my_text()

func refill_mana():
	var max_mana_this_turn = %Max_mana.max_mana
	current_mana += max_mana_this_turn
	if current_mana > max_mana_this_turn:
		current_mana = max_mana_this_turn
	update_my_text()
	
func update_my_text():
	text = str(current_mana)

@rpc("any_peer", "call_remote", "reliable")
func mirror_my_mana_change(amount):
	opponent_tower.current_mana.spend_mana(amount)
	
