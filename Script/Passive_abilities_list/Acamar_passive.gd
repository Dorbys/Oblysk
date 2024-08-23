extends Control

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

func _ready():
	tower_layer.unit_targeted_list.append(self)
	wielder.Ability1.text_for_tooltip = description

func new_lane(new_tower_layer):
	if self not in new_tower_layer.unit_targeted_list:
		new_tower_layer.unit_targeted_list.append(self)

var description = "If I have positive health after being targeted by a card, 
I get +1 DMG and +2HP"

func unit_has_been_targeted(unit, trigger):
	if unit == wielder:
		if trigger in SpellsDB.SPELLS_DB:
			if trigger[SpellsDB.TARGPOSITION] == Enums.Targeting.one_unit or trigger[SpellsDB.TARGPOSITION] == Enums.Targeting.one_ally:
				if wielder.HealthC > 0:
					Chill_up()
				
		elif  trigger in LvlupDB.LVLUPS_DB:
			if trigger[LvlupDB.TARGPOSITION] == Enums.Targeting.one_unit or trigger[LvlupDB.TARGPOSITION] == Enums.Targeting.one_ally:
				if wielder.HealthC > 0:
					Chill_up()
#	else:
#		print("Acamarpassive's target is not the wielder")
		
		
func Chill_up():
	wielder.increase_HealthM(2, 1)
	wielder.increase_AttackM(1, 1)	
	
