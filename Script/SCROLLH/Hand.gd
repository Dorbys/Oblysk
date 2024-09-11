extends ColorRect
@export var Unit_scene: PackedScene
@export var Spell_scene: PackedScene
@export var Item_scene: PackedScene
@export var Building_scene: PackedScene

@export var LVLUP_spell_scene:PackedScene

@onready var XP_panel = $"../../../../XP_Panel"
@onready var BUTTON = $"../../../../THE_BUTTON"




var CardsDrawn = 0

func drawing():
	if Base.PlayerDeck[CardsDrawn% len(Base.PlayerDeck)][0] == "creep":
		var WhichCard = Base.PlayerDeck[CardsDrawn% len(Base.PlayerDeck)][1]
		var created_card = create_creep(WhichCard)
		add_child(created_card)
		
	elif Base.PlayerDeck[CardsDrawn% len(Base.PlayerDeck)][0] == "spell":
		var WhichCard = Base.PlayerDeck[CardsDrawn% len(Base.PlayerDeck)][1]
		var created_card = create_spell(WhichCard)
		add_child(created_card)
	
	elif Base.PlayerDeck[CardsDrawn% len(Base.PlayerDeck)][0] == "item":
		var WhichCard = Base.PlayerDeck[CardsDrawn% len(Base.PlayerDeck)][1]
		var created_card = create_item(WhichCard)
		add_child(created_card)
		
	elif Base.PlayerDeck[CardsDrawn% len(Base.PlayerDeck)][0] == "build":
		var WhichCard = Base.PlayerDeck[CardsDrawn% len(Base.PlayerDeck)][1]
		var created_card = create_building(WhichCard)
		add_child(created_card)
		
	else:
		push_error("sus card in deck")
		push_error(Base.PlayerDeck[CardsDrawn% len(Base.PlayerDeck)][0])
		
	#this could be done by match
	
	collide_cards()
	CardsDrawn += 1
	
	
	
	
func create_creep(ID):
	var another = Unit_scene.instantiate()
	var DB_slot = CreepsDB.CREEPS_DB[ID]
	another.Unit_Pfp = Base.CREEP_TEXTURES[ID]	
	another.Unit_Name = DB_slot[CreepsDB.NAMEPOSITION]
	another.Unit_Attack = DB_slot[CreepsDB.ATTACKPOSITION]
	another.Unit_Health = DB_slot[CreepsDB.HEALTHPOSITION]
	another.Unit_Armor = DB_slot[CreepsDB.ARMORPOSITION]
	another.Card_Cost = DB_slot[CreepsDB.COSTPOSITION]
	another.Card_XP = DB_slot[CreepsDB.XPPOSITION]
	
	if DB_slot[CreepsDB.ABILITYPOSITION] == true:
		another.Unit_Ability_texture = Base.CREEP_ABILITY_TEXTURES[ID]
		another.Unit_Ability_cooldown = AbilitiesDB.CREEP_ABILITIES_DB[ID][AbilitiesDB.COOLDOWNPOSITION]
		another.has_ability = true
		
	another.Identification = ID
	another.HERO = 0
	
	return another
	
func create_spell(ID):
	var another = Spell_scene.instantiate()
	var DB_slot = SpellsDB.SPELLS_DB[ID]
	another.Card_Pfp = Base.SPELL_TEXTURES[ID]
	another.Card_name = DB_slot[SpellsDB.NAMEPOSITION]
	another.Card_Cost = DB_slot[SpellsDB.COSTPOSITION]
	another.Card_XP = DB_slot[SpellsDB.XPPOSITION]
	another.Targets = DB_slot[SpellsDB.TARGPOSITION]
	another.cross_lane = DB_slot[SpellsDB.CROSSLANEPOSITION]
	another.Is_played_on = DB_slot[SpellsDB.ISPLAYEDONPOSITION]
	another.Identification = ID
	
	
	return another
	
func create_item(ID):
	var another = Item_scene.instantiate()
	var DB_slot = ItemsDB.ITEMS_DB[ID]
	another.Item_Name = DB_slot[ItemsDB.NAMEPOSITION]
	another.ITEMM = DB_slot[ItemsDB.ITEMMPOSITION]
	another.Item_Pfp = Base.ITEM_TEXTURES[ID]
	another.Item_Stat = DB_slot[ItemsDB.STATPOSITION]
	another.Item_Cost = DB_slot[ItemsDB.COSTPOSITION]
	another.Item_cooldown = DB_slot[ItemsDB.COOLDOWNPOSITION]
	another.Identification = ID
	
	return another
	
func create_building(ID):
	var another = Building_scene.instantiate()
	var DB_slot = BuildDB.BUILD_DB[ID]
	another.Card_name = DB_slot[BuildDB.NAMEPOSITION]
	another.Build_Pfp = Base.BUILDING_TEXTURES[ID]
	another.Card_Cost = DB_slot[BuildDB.COSTPOSITION]
	another.Card_XP = DB_slot[BuildDB.XPPOSITION]
	another.is_aura = DB_slot[BuildDB.ISAURAPOSITION]
	another.affects = DB_slot[BuildDB.AFFPOSITION]
	another.Identification = ID
	
	return another

func draw_a_lvlup_card(ID, LVLUP_type):
	if LVLUP_type == 10:
		push_error("make lvlup units bruh")
	elif LVLUP_type == 11:
		var card =	create_lvlup_spell(ID)
		add_child(card)
	else: push_error("uknown card_type attempted to be drawn through lvlup")
	collide_cards()
		
		
		
func create_lvlup_spell(ID):
	var another = LVLUP_spell_scene.instantiate()
	var DB_slot = LvlupDB.LVLUPS_DB[ID]
	another.Card_name = DB_slot[LvlupDB.NAMEPOSITION]
	another.Card_Pfp = Base.LVLUP_CARDS_TEXTURES[ID]
	another.Card_Cost = DB_slot[LvlupDB.COSTPOSITION]
	another.Card_XP = 0
	another.Targets = DB_slot[LvlupDB.TARGPOSITION]
	another.Is_played_on = DB_slot[LvlupDB.ISPLAYEDONPOSITION]
#	another.Secondary_targets = DB_slot[LvlupDB.BONUSTARGPOSITION]
	another.cross_lane = DB_slot[LvlupDB.CROSSLANEPOSITION]
	another.TYPE = 11
	another.Identification = ID
	
	
	return another

func used_card(which):
	var target = self.get_child(which)
	var cards_xp = target.Card_XP
	var manacost = target.Card_Cost
	XP_panel.increase_xp(cards_xp)
	target.queue_free()
	if manacost >= 0:
		#so that its easy to skip cards like items
		BUTTON.tower_current_mana.spend_mana(manacost)
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	collide_cards()
	
#var mid = 1920/2
var compression = 0.8 * Base.CARD_WIDTH
var limit = 0.55 * Base.CARD_WIDTH
var handwidth = 1200
var startset = 50
#space at the beginning so that CardInHand previews aren't forcefully clipped
#var handstart = mid - (handwidth/2)
	
func collide_cards():
	#need to add control node to unitpreview (and unit1) if I want to move them by
	#their axis
	var tween = get_tree().create_tween().set_parallel(true)
	var population = get_child_count()
	var mid = ceil(population/2.0)
	var center = handwidth/2.0
	var compression_multiplier = 1
	var compression_start = 5
	if population >= compression_start:
		compression_multiplier = 1-0.09*(population-compression_start)
	var final_compression = compression*compression_multiplier
	
	if final_compression <= limit:
		final_compression = limit
#		var compressed = handwidth / (population+1)
		#this used to be important
#		print(compressed)
		for i in population:
			tween.tween_property(get_child(i),
			 "position:x", startset + ((i+1) * limit),
			0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
			
#			get_child(i).position.x= ((i+1) * compressed) - (0.1 * Base.CARD_WIDTH)
	elif round(population%2) == 1  :
		for i in population:
			tween.tween_property(get_child(i),
			 "position:x", (center + (i-mid)*final_compression),
			0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
			
#			get_child(i).position.x= ((i+1) * compressed)
	elif round(population%2) == 0  :		
		for i in population:
			tween.tween_property(get_child(i),
			 "position:x", ((center -(0.5*final_compression) + (i+1-mid)*final_compression)),
			0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
			
	else:
		push_error("number of cards in hand is neither odd nor even")



	
	
	
	
	
	
	
