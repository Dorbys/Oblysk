extends Control
#place for interparenting UNITS when moving them around

#can only have UNIT children

func _ready():
	if Base.PLAYTEST == 1:
		%DevTools.visible = false
		%XP_Panel.XP = 10
		
func lets_stop_targeting():
	for i in get_child_count():
		var target = get_child(i)
		if target.TYPE == 0:
			target.Im_no_longer_clickable()			
