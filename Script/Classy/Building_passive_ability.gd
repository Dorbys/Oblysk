extends Node

class_name Building_passive_ability

@onready var tower_layer = $"../../../../"
@onready var BUTTON = $"../../../../../../UI_layer/THE_BUTTON"

var TYPE = "building"
	#despite this not being building node, but building/control (for ability)
	#it's the part that has to be checked for type
	#and doesn't need basic_requirements() check

## Called when the node enters the scene tree for the first time.
#func _ready():
#	I could probably automate signal-receiver array
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
