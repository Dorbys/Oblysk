extends ColorRect


@onready var wielder = $".." 

@export var SCENE: PackedScene

func _get_drag_data(_at_position):
	
	
	var drag_preview = create_preview(wielder.Identification)
	set_drag_preview(drag_preview)
	drag_preview.modulate.a = .5
	return [wielder,wielder.get_parent()]

func create_preview(ID):
	var preview = SCENE.instantiate()
	assign_stats(preview, ID)
	
	
	return preview
	
func assign_stats(preview, ID):
	var DB_slot = HeroesDB.HEROES_DB[ID]
	preview.Unit_Pfp = Base.HERO_TEXTURES[ID]
	preview.Unit_Name = DB_slot[HeroesDB.NAMEPOSITION]
	preview.Unit_Attack = DB_slot[HeroesDB.ATTACKPOSITION]
	preview.Unit_Health = DB_slot[HeroesDB.HEALTHPOSITION]
	preview.Unit_Armor = DB_slot[HeroesDB.ARMORPOSITION]
	preview.Card_XP = 0
	
	preview.Unit_Ability_texture = Base.ABILITY_TEXTURES[ID]
	preview.Unit_Ability_cooldown = AbilitiesDB.HERO_ABILITIES_DB[ID][AbilitiesDB.COOLDOWNPOSITION]
	preview.has_ability = true
	
	preview.has_ability = true
	
	#bonus:
	preview.scale = Vector2(0.8,0.8)
	preview.position.x -= 100
