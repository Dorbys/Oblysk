extends Unit_passive_ability



var XP = 2
var description = "Monday: +" +str(XP) + " XP"

func _ready():
	wielder.Ability1.text_for_tooltip = description
	tower_layer.monday_phase_list.append(self)
	

func new_lane(new_tower_layer):
	if self not in new_tower_layer.monday_phase_list:
		push_error("appending Plott to: " +str(new_tower_layer))
		new_tower_layer.monday_phase_list.append(self)

func remove_myself_from_old_array(old_tower_layer):
	#when I enter a new lane, I need to remove myself from the old one
	#dunno how to get this to class
	if self in old_tower_layer.monday_phase_list:
#		push_error("length of monday list: " +str(len(old_tower_layer.monday_phase_list)))
		old_tower_layer.monday_phase_list.erase(self)
#		push_error("length of monday list: " +str(len(old_tower_layer.monday_phase_list)))
		
func monday_phase():
	if Lobby.MULTIPLAYER == false or wielder.faction == "alpha":
		Teaching()
		
func Teaching():
	push_error("XPING")
	wielder.XP_panel.increase_xp(XP) 
		
	
