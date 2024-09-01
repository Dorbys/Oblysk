extends Control

#Spawns in UI layer

@onready var hand_rect = $"../SCROLLH/HANDA/SIZECHECK/HandRect"
@onready var the_button =  $"../THE_BUTTON"

@onready var cover_beta = %CoverBeta
@onready var cover_alpha = %CoverAlpha

@onready var Card_layer1 = $"../../First_lane/Card_layer"
@onready var tower_layer1 = $"../../First_lane/Tower_layer"
@onready var arena_rect1 = $"../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect1 = $"../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var tower_mana1 = $"../../First_lane/Tower_layer/TowerA/Mana_display/Current_mana"

@onready var Card_layer2 = $"../../Mid_lane/Card_layer"
@onready var tower_layer2 = $"../../Mid_lane/Tower_layer"
@onready var arena_rect2 = $"../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect2 = $"../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var tower_mana2 = $"../../Mid_lane/Tower_layer/TowerA/Mana_display/Current_mana"

@onready var Card_layer3 = $"../../Last_lane/Card_layer"
@onready var tower_layer3 = $"../../Last_lane/Tower_layer"
@onready var arena_rect3 = $"../../Last_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect3 = $"../../Last_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var tower_mana3 = $"../../Last_lane/Tower_layer/TowerA/Mana_display/Current_mana"

var Card_layer
var tower_layer 
var arena_rect 
var abarena_rect 
var tower_mana 






var TList = []
#TList[0] is automatically the unit that the card was dropped on
var I_want_targets = 3
#at how many targets the function of spell will trigger
var Card_ID = null
#to know which spell will be called
var Ability_ID = null
#which ability
var Item_ID = null
#which item
var My_hand_position = null
#so that we know which card to remove once spell resolves
var origin_ability = null
#to activate cooldown only if the ability is used
var origin_item = null
#to activate cooldown only if the item is used


var from_lvlup_card = false
var from_item = false
#to know which DB to get info from
var Secondary_targets 
#Enums.Targeting.something
#and since it specifies ally and enemy we can 
	#determine whether we can target only Alpha, only Beta or both
	
var target_faction = null
#"alpha" or "beta" or "both"
#used for determining lanes, since unit targeting is done via Enums



#skipping whether its hero or creep for now during secodnary targeting

var DB = SpellsDB
var DBList = SpellsDB.SPELLS_DB
#so that it can be changed to LVLUP or ItemDB 
var base_text
var cancel_text = ", right-click to cancel"

func _ready():
	new_lane()
	
	if Secondary_targets == Enums.Targeting.lane:
		the_button.global_lane_is_being_picked(self,target_faction)
		#target_faction is for specifying lanes that will receive the effect
			#you can target the entire "Base.tscn" but effect is only for one
			#mhm

	else:
		Card_layer.lets_target_a_unit(self)
	#
	
	if from_lvlup_card == true:
		DB = LvlupDB
		DBList = LvlupDB.LVLUPS_DB
	if from_item == true:
		DB = ItemsDB
		DBList = ItemsDB.ITEMS_DB
	#specify where the result function will be called from
	
	match Secondary_targets:
		Enums.Targeting.one_unit:
			#pass
			#nothing happens because ignore is set by default
				#no idea why pass was here
			arena_rect.a_spell_is_being_dragged("Unit")
			abarena_rect.a_spell_is_being_dragged("Unit")
			write_base_text("unit")
			
		Enums.Targeting.one_ally:
			cover_beta.mouse_filter = Control.MOUSE_FILTER_STOP
			arena_rect.a_spell_is_being_dragged("Unit")
			write_base_text("ally")
			
		Enums.Targeting.one_enemy:
			cover_alpha.mouse_filter = Control.MOUSE_FILTER_STOP
			abarena_rect.a_spell_is_being_dragged("Unit")
			write_base_text("enemy")
		Enums.Targeting.lane:
			#being able to target the lane is done sooner in ready()
			write_base_text("lane")
	

	%targeting_what.text = base_text + cancel_text
	printerr("Covering is locking") 
	Base.lock_pass_button()
	
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	if Secondary_targets != Enums.Targeting.lane:
		the_button.global_lets_hide_abilities_and_items()
		#because card_preview exiting tree reshows them
	
func new_lane():
	match Base.current_lane:
		1:
			Card_layer = Card_layer1
			tower_layer = tower_layer1
			arena_rect = arena_rect1
			abarena_rect = abarena_rect1
			tower_mana = tower_mana1
		2:
			Card_layer = Card_layer2
			tower_layer = tower_layer2
			arena_rect = arena_rect2
			abarena_rect = abarena_rect2
			tower_mana = tower_mana2
		3:
			Card_layer = Card_layer3
			tower_layer = tower_layer3
			arena_rect = arena_rect3
			abarena_rect = abarena_rect3
			tower_mana = tower_mana3
	
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		delete_myself(false)




func _process(_delta):
	if len(TList) < I_want_targets:
		pass
	elif len(TList) == I_want_targets:
		match I_want_targets:
			1: handle_one_target()
			2: handle_two_targets()
			_: push_error("I_want_targets is set wrong: " +str(I_want_targets))			
	else: 
		push_error("Too many targets :(")
		
		
func handle_one_target():
	if Card_ID != null:
		await tower_layer.unit_targeted_signal(TList[0],DBList[Card_ID])
		#FOR PASSIVES
		await DB.call(str(DBList[Card_ID][0]),TList[0])
		delete_myself(true)
		return
	elif Ability_ID != null:
		origin_ability.activate_cooldown()
		await tower_layer.unit_targeted_signal(TList[0],AbilitiesDB.HERO_ABILITIES_DB[Ability_ID])
		await get_tree().create_timer(Base.FAKE_DELTA).timeout 

		#FOR PASSIVES
		AbilitiesDB.call(str(AbilitiesDB.HERO_ABILITIES_DB[Ability_ID][0]),TList[0])
		delete_myself(true)
		return
		
func handle_two_targets():
	if Card_ID != null:
		
		await DB.call(str(DBList[Card_ID][0]),TList[0],TList[1])
		
		await tower_layer.unit_targeted_signal(TList[0],DBList[Card_ID])
		await tower_layer.unit_targeted_signal(TList[1],DBList[Card_ID])	
		#FOR PASSIVES
		
		delete_myself(true)
		return #so that process stop immediately
	elif Ability_ID != null:
		origin_ability.activate_cooldown()
		
		await tower_layer.unit_targeted_signal(TList[0],AbilitiesDB.ABILITIES_DB[Ability_ID])
		await tower_layer.unit_targeted_signal(TList[1],AbilitiesDB.ABILITIES_DB[Ability_ID])
		#FOR PASSIVES
		
		#not sure why abilites done via DB and DBList		
		
		await AbilitiesDB.call(str(AbilitiesDB.ABILITIES_DB[Ability_ID][0]),TList[0],TList[1])
		delete_myself(true)
		return
	elif Item_ID != null:
		origin_item.activate_cooldown()
		
		await tower_layer.unit_targeted_signal(TList[0],DBList[Item_ID])
		await tower_layer.unit_targeted_signal(TList[1],DBList[Item_ID])	
		#FOR PASSIVES mbhere
		
		await DB.call(str(DBList[Item_ID][0]),TList[0],TList[1])
		#Use 'await' at the end of DB-functions
		
		delete_myself(true)
		return
		
	else: push_error("covering has 2 targets but nothing to call")

func delete_myself(used):
	printerr("covering is being deleted")
	the_button.global_lets_stop_targeting()
	the_button.global_lets_reshow_abilities_and_items()


	arena_rect.TargetingSpell = 0
	abarena_rect.TargetingSpell = 0
	if used == true:
		if My_hand_position != null:
			hand_rect.used_card(My_hand_position)


	if Secondary_targets == Enums.Targeting.lane:
		the_button.global_lane_is_no_longer_being_picked()
			
	Base.unlock_pass_button()		
	self.queue_free()


func write_base_text(target):
#	if I_want_targets > 1:
#		#cuz this is generated even when clicking abilities that don't target anything
	match target:
		"unit":
			#because here UNIT stands for both allies and enemies, not creepsheroes
			if arena_rect.Are_heroes_being_played_on == true:
				if arena_rect.Are_creeps_being_played_on == true:
					base_text = "Targeting a unit"
				else:
					base_text = "Targeting a hero"
			elif arena_rect.Are_creeps_being_played_on == true:
				base_text = "Targeting a creep"
					
		"ally":
			if arena_rect.Are_heroes_being_played_on == true:
				if arena_rect.Are_creeps_being_played_on == true:
					base_text = "Targeting an allied unit"
				else:
					base_text = "Targeting an allied hero"
			elif arena_rect.Are_creeps_being_played_on == true:
				base_text = "Targeting an allied creep"
		"enemy":
			if abarena_rect.Are_heroes_being_played_on == true:
				if abarena_rect.Are_creeps_being_played_on == true:
					base_text = "Targeting an enemy unit"
				else:
					base_text = "Targeting an enemy hero"
			elif abarena_rect.Are_creeps_being_played_on == true:
				base_text = "Targeting an enemy creep"
		"lane":
			base_text = "Targeting a lane"
