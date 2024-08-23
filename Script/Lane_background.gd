extends TextureRect

@onready var lane = $"../.."




func _ready():
	var loadtexture
	match lane.name:
		"First_lane":
			loadtexture = load("res://Assets/Maps/L1.png")
		"Mid_lane":
			loadtexture = load("res://Assets/Maps/L2.png")
		"Last_lane":
			loadtexture = load("res://Assets/Maps/L3.png")
	texture = loadtexture
