extends Control


var aura_unique_id
var Build_name
#carried from above
var text_for_tooltip = "-1 armor to enemies"

func do_I_affect_this(target):
	if target.TYPE == 0:
		return true
	else: return false
