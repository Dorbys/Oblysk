extends Unit_passive_ability



var DAMAGE
var description 
var projectile

func _ready():
	projectile = preload("res://Scenes/VFX/Projectile1.tscn")
	DAMAGE = AbilitiesDB.MP5_DAMAGE
	description = AbilitiesDB.MP5_description
	if Lobby.MULTIPLAYER == true:
		if wielder.faction == "alpha":
			if Lobby.host == true:
				LvlupDB.railgun_host_owner = wielder.MY_UNIQUE_UNIT_KEY
				push_error("assigning host owner the value of: " +str(wielder.MY_UNIQUE_UNIT_KEY))
			else:
				LvlupDB.railgun_join_owner = wielder.MY_UNIQUE_UNIT_KEY
		else:
			if Lobby.host == true:
				LvlupDB.railgun_join_owner = wielder.MY_UNIQUE_UNIT_KEY
				#push_error("assigning host owner the value of: " +str(wielder.MY_UNIQUE_UNIT_KEY))
			else:
				LvlupDB.railgun_host_owner = wielder.MY_UNIQUE_UNIT_KEY 
	else:
		LvlupDB.railgun_host_owner = wielder.MY_UNIQUE_UNIT_KEY
		
	wielder.Ability1.text_for_tooltip = description
	var ab = get_parent()
	ab.connection_to_passive = self
	tower_layer.monday_phase_list.append(self)
	tower_layer.lvlup_list.append(self)
	

func new_lane(new_tower_layer):
	if self not in new_tower_layer.monday_phase_list:
		push_error("appending Kimmedi to: " +str(new_tower_layer))
		new_tower_layer.monday_phase_list.append(self)
#	if self not in new_tower_layer.lvlup_list:	
#		tower_layer.lvlup_list.append(self)

func remove_myself_from_old_array(old_tower_layer):
	#when I enter a new lane, I need to remove myself from the old one
	#dunno how to get this to class
	if self in old_tower_layer.monday_phase_list:
#		push_error("length of monday list: " +str(len(old_tower_layer.monday_phase_list)))
		old_tower_layer.monday_phase_list.erase(self)
#		push_error("length of monday list: " +str(len(old_tower_layer.monday_phase_list)))
	
	
	
func monday_phase():
	if Lobby.MULTIPLAYER == false or wielder.faction == "alpha":
		await MP5()
		
		
var snipe_damage = 3
func new_snipe_damage(new_dmg):
	if wielder.faction == "alpha":
		#multiplayer stuff
		snipe_damage = new_dmg
		increase_stats_of_snipes()
	
func increase_stats_of_snipes():
	LvlupDB.LVLUPS_DB[wielder.Identification][LvlupDB.COSTPOSITION] = snipe_damage -1	
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout
	var handa = wielder.hand_rect
	var population = handa.get_child_count()
	for i in population:
		var target_card = handa.get_child(i)
		if target_card.TYPE == "lvlup_spell" and target_card.Identification == 3:
			target_card.update_stats()
			target_card.update_description()
	
func unit_lvlups(unit):
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout
	if unit == wielder:
		increase_stats_of_snipes()

		
		
func MP5():
	var sister = "MP5"
	push_error("MPING")
	var population = wielder.OPrena.get_child_count()
	var potential_targets = []
	for i in population:
		var mb_target = wielder.OPrena.get_child(i)
		if mb_target.TYPE ==  "unit":
			potential_targets.append(mb_target)
	var length = len(potential_targets)
	if  length > 0:
		var gamba = randi()%length
		var target = potential_targets[gamba]
#		var expected_damage = DAMAGE - target.ArmorC
#		if expected_damage < 0:
#			expected_damage = 0
#		#really gotta put this inside take_dmg function....
#			#usure?
#		target.take_damage(expected_damage)
		#projectile_animation(target)
		
		await AbilitiesDB.call(sister,target)
		
		if Lobby.MULTIPLAYER == true and wielder.faction == "alpha":
			await wielder.card_layer.make_my_mirror_unit_receive_ability_call(target.MY_UNIQUE_UNIT_KEY, sister)
		
#func projectile_animation(target):
	#var another = projectile.instantiate()
	#another.destination = target.get_global_position()
	#get_parent().add_child(another)	
