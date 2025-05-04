extends Control
#place for interparenting UNITS when moving them around

#can only have UNIT children

func _ready():
	if Base.PLAYTEST == true:
		%DevTools.visible = false
		%XP_Panel.XP = Base.STARTING_XP
		%Opponent_XP_panel.XP = Base.STARTING_XP
		
func lets_stop_targeting():
	for i in get_child_count():
		var target = get_child(i)
		if target.TYPE == "unit":
			target.Im_no_longer_clickable()			
