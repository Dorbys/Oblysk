extends Control

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

var DAMAGE = 3
var description = "Monday: I deal " + str(DAMAGE) + " physical damage to a random enemy"

func _ready():
	wielder.Ability1.text_for_tooltip = description
	var ab = get_parent()
	ab.connection_to_passive = self
	tower_layer.monday_phase_list.append(self)
	tower_layer.lvlup_list.append(self)
	

func new_lane(new_tower_layer):
	if self not in new_tower_layer.monday_phase_list:
		new_tower_layer.monday_phase_list.append(self)
	if self not in new_tower_layer.lvlup_list:	
		tower_layer.lvlup_list.append(self)

func monday_phase():
	MP5()
		
		
var snipe_damage = 3
func new_snipe_damage(new_dmg):
	snipe_damage = new_dmg
	increase_stats_of_snipes()
	
func increase_stats_of_snipes():
	LvlupDB.LVLUPS_DB[wielder.Identification][LvlupDB.COSTPOSITION] = snipe_damage -1	
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout
	var handa = wielder.hand_rect
	var population = handa.get_child_count()
	for i in population:
		var target_card = handa.get_child(i)
		if target_card.TYPE == 11 and target_card.Identification == 3:
			target_card.update_stats()
			target_card.update_description()
	
func unit_lvlups(unit):
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout
	if unit == wielder:
		increase_stats_of_snipes()

		
		
func MP5():
	
	print("MPING")
	var population = wielder.OPrena.get_child_count()
	var potential_targets = []
	for i in population:
		var mb_target = wielder.OPrena.get_child(i)
		if mb_target.TYPE ==  0:
			potential_targets.append(mb_target)
	var length = len(potential_targets)
	if  length > 0:
		var gamba = randi()%length
		var target = potential_targets[gamba]
		var expected_damage = DAMAGE - target.ArmorC
		if expected_damage < 0:
			expected_damage = 0
		#really gotta put this inside take_dmg function....
		target.take_damage(expected_damage)
		
	
