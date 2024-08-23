extends PanelContainer


var caller
#the node that upon hovering on I am created

func disappear_when_THE_BUTTON_is_pushed():
	if caller != null:
		caller.set_process(false)
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	queue_free()
