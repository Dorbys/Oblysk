extends Unit_passive_ability



func _ready():
	tower_layer.unit_targeted_list.append(self)
	wielder.Ability1.text_for_tooltip = description

func new_lane(new_tower_layer):
	if self not in new_tower_layer.unit_targeted_list:
		new_tower_layer.unit_targeted_list.append(self)

var description = "If I have positive health after being targeted by a card, 
I get +1 DMG and +2HP"

func remove_myself_from_old_array(old_tower_layer):
	#when I enter a new lane, I need to remove myself from the old one
	#dunno how to get this to class
	if self in old_tower_layer.unit_targeted_list:
#		push_error("length of unit_targeted_list: " +str(len(old_tower_layer.unit_targeted_list)))
		old_tower_layer.unit_targeted_list.erase(self)
#		push_error("length of unit_targeted_list: " +str(len(old_tower_layer.unit_targeted_list)))
		
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
		else:
			push_error("neither spell nor lvlupspell")
	else:
		#push_error("Acamarpassive's target is not the wielder")
		pass
		
		
func Chill_up():
	wielder.increase_HealthM(2, 1)
	wielder.increase_AttackM(1, 1)	
	
