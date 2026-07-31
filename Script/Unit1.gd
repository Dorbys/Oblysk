extends Control

@export var EFFECT: PackedScene
@export var IEFFECT: PackedScene
@export var ATEFFECT: PackedScene
@export var LVLUPEFFECT: PackedScene
@export var COVERING: PackedScene
@export var LVLUPPING: PackedScene
@export var stat_change_visual: PackedScene

@onready var D12 = $"../../../../../../../D12"
@onready var UI_layer = $"../../../../../../../UI_layer"
@onready var effect_layer = $"../../../../../../../Effect_layer"
@onready var hand_rect = $"../../../../../../../UI_layer/SCROLLH/HANDA/SIZECHECK/HandRect"
@onready var XP_panel = $"../../../../../../../UI_layer/XP_Panel"


@onready var which_lane  = $"../../../../../.."
@onready var card_layer = $"../../../../.."
@onready var tower_layer = $"../../../../../../Tower_layer"
@onready var tower_mana = $"../../../../../../Tower_layer/TowerA/Mana_display/Current_mana"
@onready var MYrena_rect = $".."
@onready var SCROLLA = $"../../../.."

@onready var Ability1 = $"Slacksus/Ability1"
@onready var lane_auras = %Lane_auras
@onready var position_auras = %Position_auras
#used for inflicting position based auras
@onready var particle_holder: Control = %particle_holder
@onready var sfx_base: AudioStreamPlayer2D = %SFX_base





var Unit_Name = "E"
var Card_pfp 
var Unit_Ability_texture
var Unit_Ability_cooldown = 0
var Passiveness = true
# to know whether the ability is passive = true nebo active = false
var Passive_Trigger
var Unit_Icon 
var Unit_Attack = 1
var Unit_Health = 2
var Unit_Armor = 0
var Lvlup_xp = 0
#increased only for heroes
var Grants_xp = 0
#increased only for creeps
var HERO: bool = false
var Identification = 3




#var UNIT = 1
#var SPELL = 0
var TYPE:String = "unit"
var VOIDING = 1
#idk
var SETT = 1
var SITT = 0

var HealthC = Unit_Health
var AttackC = Unit_Attack
var ArmorC = Unit_Armor
#StatC = StatCurrent
#StatM = StatMax
var HealthM = Unit_Health
var AttackM = Unit_Attack
var ArmorM = Unit_Armor

var Attack_from_items = 0
var Health_from_items = 0
var Armor_from_items = 0
var Resist_from_items = 0

var LEVEL = 0


#######################################################################
### 						Combat modifiers 						###
#######################################################################

var Siege = false
#whether this unit can siege
var besieged_damage = 0
#how much damage is being sent to my tower because Im being sieged
var overkill_damage = 0
# damage tbtb - healthC
#how much more dmg I'm goind to take than I can absorb
#only used with siege if opposer does have Siege













var Aiming = 0
var Iteming = 0
#for hover over effects when spells or items

var Im_targeted = 0
#for when player needs to targets more than what is being dragged on
var Targeter = null
#the covering node containing script with TList

var placeholder = "placeholder"
var weapon_equipped = 0
var special_equipped = 0
var armour_equipped = 0
var item_equipped = [placeholder, weapon_equipped,special_equipped,armour_equipped]
var item_script_folders = ["Placeholder2/", "Placeholder/", "Weapons/", "Specials/", "Armours/"]
#for loading item scripts

#var targeting = "straight"
#for curving
var OPrena
#the opposite arena
var damage_to_be_taken = 0
#how much damage I will be dealt next combat phase
#var damage_used_up_1 = 0
#var damage_used_up_2 = 0
#how much of my damage is being directed to units (NOT TOWERS)
#1 For the opposing target, 2 for side target
# = if 0+0 all dmg goes to tower
#var side_target = null
#enemy I'm curving into on left or right
var straight_target = null
#the tower or the opposing enemy

var death_shader = preload("res://Assets/Shaders/ShadeShade.gdshader")
#makes hero_jpeg grayscale

var animating:bool = false
#when dueling or other animations that shouldn't be interrupted by eg getting hit

var flinching:bool = true
#whether to show getting_hit_animation #used in eg duel 

var faction 
# "alpha" or "beta"
#used for determining which auras should affect the unit and which not

var LVLUP_type
#used for determining what TYPE of card should my lvlup generate

var Card_from_lvlup = false
#because lvlup cards have separate DBs

var has_ability = false
#used for hiding the ability if there is none on this unit

var NATURAL_CHILD_COUNT = 6
#used for cleaning off effects such as being targeted by item during equipment
#last modified: increased to 6 because of particle_holder


var my_lane = 0
#used for multilane spells to be able to target and normal don't

var alive:bool = true
#so that I can stop their passives from triggering when they're in graveyardnshit

var opposable = 1
#whether I can be considered an opposer
#used for two units dying across each other, so that unit doesnt target a dying unit

var has_position_aura = false
#used to add aurawielder to array in arenarects to make checking whther position
#auras have to be updated easier

var my_damage_was_annuled = false
#used when a unit that I'm attacking is having it's presence annulled 
#for example when blinking

var readied = false
#turns true after any second_ready function
	#used for spawning units without second_readying them
	#to then mass ready them
	
var visual_center:Vector2

#######################################################################
### 					MULTIPLAYER VARIABLES						###
#######################################################################

#================================================================
var MY_UNIQUE_UNIT_KEY: int
#every unit is granted a unique number based on when it's created
	#for MP
	#number corresponds to it's position in the Lobby.universal_global_unit_array
	#first 10 slots are reserved for heroes
	
var my_target_deployment_lane: int = 0
	# 1-3 based on which lane player decides to deploy me 
	#is sent over to the other player so that SpawnRect.deploy_all() knows where 
		#to send enemy heroes 
		#sync?
	#reset to 0 after reparenting to DeployRect
		
#================================================================

#var sent_over_to_opponent:bool = false
#Trying to implement sending data about unit deployment in waves,
	#this will be checked and modified in such wave

#######################################################################
### 					SPECIAL CASE VARIABLES 						###
#######################################################################
#Used for special cases such as being able to lvlup, which are rarely modified

var can_lvlup = true

#######################################################################
### 						2BLOADED VARIABLES 						###
#######################################################################

var equip_sfx




func _ready():
	################################################################
	if HERO == false:
		Lobby.unique_unit_key += 1
		MY_UNIQUE_UNIT_KEY = Lobby.unique_unit_key
		Lobby.universal_global_unit_array.append(self)
		
		
	if MYrena_rect.MY_identity == "A":
		faction = "alpha"
	elif MYrena_rect.MY_identity == "B":
		faction = "beta"
	else: push_error("MYrenaRect has conflicting OP_identity")
	
	if HERO == true:
		var my_slot:int
		if Lobby.host == true:
			if faction == "alpha":
				my_slot = Base.HeroDeck.find(Identification)
			else:
				my_slot = 5 + Base.OpponentHeroDeck.find(Identification)
		else: 
			if faction == "alpha": 
				my_slot = 5+ Base.HeroDeck.find(Identification)
			else:
				my_slot = Base.OpponentHeroDeck.find(Identification)
				
		Lobby.universal_global_unit_array[my_slot] = self
		MY_UNIQUE_UNIT_KEY = my_slot
#	push_error("UNIT: " +str(MY_UNIQUE_UNIT_KEY) +" CREATED AS: " +str(faction) + " at " +str(get_index()))
	################################################################
	#that part was for unique_unit_key
	#has to be done asap cuz sync
	################################################################
	
	OPrena = MYrena_rect.OPrena_rect
#	%NAME.text = Unit_Name
	%ATK.text = str(Unit_Attack)
	%HP.text = str(Unit_Health)
	%AR.text = str(Unit_Armor)	
	#increase_damage_to_be_taken(0)
	#moved further, might help the opposer losing
	
	%ATK.modulate = Base.Black_color
	%HP.modulate = Base.Black_color
	if Unit_Armor != 0:
		%AR.visible = true
		%AR.modulate = Base.Black_color
	#increase_damage_to_be_taken(0)
	check_damage_to_be_taken()

	
	%UNIT_JPEG.texture = Card_pfp
	Ability1.texture = Unit_Ability_texture
	Ability1.CooldownM = Unit_Ability_cooldown
	if has_ability == true:
		if Unit_Ability_cooldown != 0:
			Passiveness = false
			Ability1.Im_active_and_ready()
		else:
#			if HERO == true:
#				Passive_Trigger = AbilitiesDB.HERO_ABILITIES_DB[Identification][AbilitiesDB.PASSIVETRIGPOSITION]
#			else:
#				Passive_Trigger = AbilitiesDB.CREEP_ABILITIES_DB[Identification][AbilitiesDB.PASSIVETRIGPOSITION]
			#not sure what this was for,  earlier passives wtf
			
			Ability1.Im_passive_and_ready()
	if HERO == false:
		%weapon_slot.visible = false
		%special_slot.visible = false
		%armor_slot.visible = false
		
	refresh_my_lane_int()
	#just sets the int
	
	
	
	
	
	
	HealthM = Unit_Health
	AttackM = Unit_Attack
	HealthC = Unit_Health
	AttackC = Unit_Attack
	ArmorC = Unit_Armor
	
#	if HERO == false:
#		Grants_xp = CreepsDB.CREEPS_DB[Identification][CreepsDB.XPPOSITION]
	#why was this in Unit1.gd ????????
	
	if HERO == true:
		Lvlup_xp = HeroesDB.HEROES_DB[Identification][HeroesDB.XPPOSITION]
		
		if faction == "beta":
			XP_panel = $"../../../../../../../UI_layer/Opponent_info/Opponent_XP_panel"
	#Isnt shown on text so its okay to load here
	
	
	
	death_shader = load("res://Assets/Shaders/ShadeShade.gdshader")
#	var death_material : ShaderMaterial = ShaderMaterial.new()

	if Passiveness == true and has_ability == true:
		var Passive_ability_node = Control.new()
		var loaded_script
		if HERO == true:
			loaded_script = load("res://Script/Passive_abilities_list/" +str(HeroesDB.HEROES_DB[Identification][HeroesDB.NAMEPOSITION])  +"_passive.gd")
		else:	
			loaded_script = load("res://Script/Creep_abilities_list/" +str(CreepsDB.CREEPS_DB[Identification][CreepsDB.NAMEPOSITION])  +"_passive.gd")
		Passive_ability_node.set_script(loaded_script)
		Passive_ability_node.size = Vector2(0,0)
		Ability1.add_child(Passive_ability_node)
		
		
	LVLUP_type = LvlupDB.LVLUPS_DB[Identification][LvlupDB.TYPEPOSITION]
	#used for determining the type of lvlup card
	
	get_visual_center()
	equip_sfx = load("uid://cn5ktynbjrdjj")
	
	#if Base.Main_phase == 1:
		#await get_tree().create_timer(0.2).timeout 
		#check_if_I_put_space_between_curving()
		
#	curve_rng()
	#fuck it lets call this from the spawning source
	
	#unfuck it and lets call this from second_ready()
	
		

	
	
	
func second_ready():
	#needs to be called together with _ready() for a proper initiation
		#of a unit, but the delay between the two can be modified
	if readied == false:
		
		await get_tree().create_timer(Base.FAKE_GAMMA).timeout 
		curve_straight() #curve_rng()
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		increase_damage_to_be_taken(0)
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		lane_aura_check()	
		
		readied = true
	#else:
		#push_error("secondready called, but unit was already readied")
	
#func second_ready_without_curve_rng():
	##Used in multiplayer since curving is done only for at host
		#since no curving, this was the same as second_ready()
	#if readied == false:
		#await get_tree().create_timer(Base.FAKE_DELTA).timeout
		#increase_damage_to_be_taken(0)
		#await get_tree().create_timer(Base.FAKE_DELTA).timeout
		#lane_aura_check()	
		#
		#refresh_my_combat_damage()
		#
		#readied = true
	
	
func respawn(silent = 0):
#	sent_over_to_opponent = false
	#because my slot has to be synced again
	
	#appear_alive()
	leave_draggable_state()
	scale = Vector2(1,1)
	await new_lane()
	lane_aura_check()
	HealthC = HealthM
	AttackC = AttackM
	if MYrena_rect.MY_identity == "B":
		#==0 Means we are in Abarena
		self.position.y = MYrena_rect.BOFFSET
	else:
		self.position.y = MYrena_rect.AOFFSET
#	MYrena_rect.place_me_pls(self, self.get_index())

	
	
	updateS(false) 
	# silent value is USED FOR DEPLOYMENT #wtf
	
	my_damage_was_annuled = false
	
	#await get_tree().create_timer(Base.FAKE_GAMMA).timeout 

	#check_if_I_put_space_between_curving()
	

func land():
	#blink ig
	push_error("landing")
	await new_lane()
	curve_straight()
	
	
	#var opposer = await get_opposer()
	#if opposer.TYPE == "unit":
		#straight_target = opposer
	#else:
		#straight_target = MYrena_rect.OPTower
	
		
	#CURVEREMOVED
	
	#curve_rng()
	#if opposer.TYPE == "unit":
		#opposer.curve_rng()

#func check_if_I_put_space_between_curving():
	#if Base.Main_phase == 1:
		#var opposer = await get_opposer()
		#if opposer.TYPE == "void":
			##only if I brought a void here I couldve messed up
			#var id = get_index()
			#if id > 0:
				#var target1 = MYrena_rect.get_child(id-1)
				#if target1.TYPE == "unit" and target1.targeting == "right":
					#target1.curve_straight()
##					print("made him curve straight from right")
			#if id < MYrena_rect.get_child_count() -1 :
				#var target1 = MYrena_rect.get_child(id+1)
				#if target1.TYPE == "unit" and target1.targeting == "left":
					#target1.curve_straight()
##					print("made him curve straight from left")
##			print("ID is: " +str(id))
		#else:
			#pass
##			print("opposer aint void")
	#else:
		#pass
##		print("main phase aint 1")
	

func pre_deploy_respawn():
		scale = Vector2(Base.pre_deploy_scale_down,Base.pre_deploy_scale_down)
		HealthC = HealthM
		AttackC = AttackM
		hide_incoming_death()
		damage_to_be_taken = 0
		overkill_damage = 0 
		besieged_damage = 0
		alive = true
		updateS(true)

	
	
	
	
#	var tween = create_tween()
#	tween.tween_property(self, "modulate:a", 1, card_layer.visible_death_anim_length)
	



















func increase_AttackM(how_much, loudness:bool):
	if loudness == true:
		stat_change_animation("AttackM", how_much)
	annul_my_damage()
	AttackM += how_much
	AttackC += how_much
	if loudness == true:
		updateS()
	
#func decrease_AttackM(how_much, loudness):
#	#I know
#	AttackM -= how_much
#	AttackC -= how_much
#	if loudness == 1:
#		updateS()
		
func increase_HealthC(how_much):
	if Base.Combat_phase == false:
		stat_change_animation("HealthC", how_much)
	HealthC += how_much
	if HealthC > HealthM:
		HealthC = HealthM
	updateS()
	refresh_combat_damage_on_me()
	
		
func increase_HealthM(how_much, loudness:bool):
	if loudness == true:
		stat_change_animation("HealthC", how_much)
	HealthM += how_much
	HealthC += how_much
	if loudness == true:
		updateS()
	refresh_combat_damage_on_me()
		
func increase_ArmorM(how_much,loudness:bool = true):
	if loudness == true:
		stat_change_animation("ArmorM", how_much)
	await annul_damage_directed_to_me()
	ArmorM += how_much
	ArmorC += how_much
	await redirect_damage_to_me_again()
	

	
	if loudness == true:
		
		updateS()

func updateS(silent = false):
	%ATK.text = str(AttackC)
	%HP.text = str(HealthC)
	%AR.text = str(ArmorC)
	
	if AttackC > Unit_Attack:
		%ATK.modulate = Base.Green_color
	elif AttackC < Unit_Attack:
		%ATK.modulate = Base.Red_color
	else: 
		%ATK.modulate = Base.Black_color
			
	if HealthC < HealthM:
		%HP.modulate = Base.Red_color
	elif HealthC > Unit_Health:
		%HP.modulate = Base.Green_color
	elif Unit_Health == HealthM:
		%HP.modulate = Base.Black_color
	
	if ArmorC < Unit_Armor:
		%AR.modulate = Base.Red_color
		if ArmorC != 0:
			%AR.visible = true
		else:
			%AR.visible = false
	elif ArmorC > Unit_Armor:
		%AR.modulate = Base.Green_color
		%AR.visible = true
	else:
		if ArmorC != 0:
			%AR.visible = true
		else:
			%AR.visible = false
		%AR.modulate = Base.Black_color	

		
	check_damage_to_be_taken()
		
	if silent == false:
		refresh_my_combat_damage()
		
func heal(amount:int):
	if HealthC < HealthM:
		heal_applied_animation()
		increase_HealthC(amount)		

	
func take_damage(Damage):
	if Base.Combat_phase == false: 
		stat_change_animation("HealthC", -Damage)
	HealthC -= Damage
	if HealthC <= 0:
		Death_sudden(Damage)
		return true
	else:
		if Base.Combat_phase == false: 
			getting_hit_animation()

		updateS()
		increase_damage_to_be_taken(0)
		return false
	
func Death_sudden(DMG):
	appear_dead()
	
#	print("trigging death_sudden")
	
	
	var id = get_index()
	var par = get_parent()
	death_animation(DMG)
	var opposer = await get_opposer()
		
	if Base.Combat_phase == false:
		#push_error("nolongering")
		#if targeting == "straight":
			#push_error("nolongering straight")
			#if straight_target != null:
		if straight_target != null:
			straight_target.Im_no_longer_attacked_only_by(self,Siege)
		else:
			push_error("attempted to call funtion Im_no_longer_attacked_only_by() on a null target")
#				print(str(Unit_Name) +"is no longer attacking str target")
		#else:
			#push_error("nolongering to a side")
			#if side_target != null:
				#side_target.Im_no_longer_side_attacked_by(self)
			#if straight_target != null:
				#straight_target.Im_no_longer_straight_attacked_by(self)
						
		
		
		refresh_neighbours_from_my_death(id,par,opposer)
	

	
	
#	self.reparent(card_layer)
	
	await get_tree().create_timer(Base.visible_death_anim_length).timeout
	if HERO == false:
		card_layer.Death_care(self, id, par)
	else :
		clean_myself_from_effects()
		await remove_position_and_lane_auras()
		card_layer.Hero_death_care(self, id, par)
	
	if (has_position_aura == true):
		Ability1.get_child(2).remove_aura_on_death()
	

func take_combat_damage():
	take_damage(damage_to_be_taken)


func refresh_neighbours_from_my_death(id, _parent, opposer):
	#push_error(str(Unit_Name) + " is refreshing ngh from its death at " +str(get_index()))
##	if Base.Combat_phase == false:
##already checked in parent function
	#push_error("type: " +str(opposer.TYPE) + " alive: " +str(opposer.alive))
	if opposer.TYPE == "unit" and opposer.alive == true:
		opposer.ignore_opposer()
		##if opposer.Siege == true: # and opposer.targeting == "straight"
			##card_layer.unit_no_longer_being_sieged(faction, besieged_damage)
			##nolonger doesnt work when ignoring opposer since 26
		#besieged_damage = 0
		#overkill_damage = 0
			##not nullified for when curving ig
			#
			#
#	await get_tree().create_timer(Base.MICRO_TIME).timeout

	#var comp = id-1
	#if comp> -1:
		#var left_opponent = OPrena.get_child(comp)
		#if left_opponent.TYPE == "unit" and left_opponent.targeting == "right":
			#left_opponent.curve_straight()
			
#	await get_tree().create_timer(Base.MICRO_TIME).timeout
		
	#comp = id+1
	#if comp < OPrena.get_child_count():
		#var right_opponent = OPrena.get_child(comp)
		#if right_opponent.TYPE == "unit" and right_opponent.targeting == "left":
			#right_opponent.curve_straight()


	
	
	
	
	
#	for i in 3:
#		var comp = id-1+i
#		if comp > -1 and comp< parent.get_child_count():
#			var target = OPrena.get_child(comp)
#			#gets the neighbours on the opposite lane
#			if target.TYPE == "unit":
#				if i != 1 and opposer.TYPE != "unit:
#					#if I die and there is void opposite of me,
#					# the OPneighbours on left and right must: 
#					if target.targeting != "straight":
#						target.curve_rng()
#						#recurve if they are curved into me
#					else:
#						target.refresh_my_combat_damage() 
#
						
						# Yeaah this needs more work
	


#========================================================================
#							PHASES
#========================================================================

func cleanup_phase():
	if Passiveness == false:
		Ability1.decrease_cooldown()
	# NOT HAVING AN ABILITY COUNTS AS HAVING A ZERODOING PASSIVE
	decrease_item_cooldowns()
	
#	elif Passiveness == true:
#		if Passive_Trigger == Enums.PassiveTriggers.cleanup_phase:
#			var Target = whats_passive_abilitys_target()
##			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#
#
#			AbilitiesDB.call(str(AbilitiesDB.ABILITIES_DB[Identification][0]),Target)
		#MAY THIS BE RESOLVED VIA %PASSIVEABILITY	
		#	
		


################################################################
#I think this is relict code	
#that I wrote for the second time LULE

func before_prep_phase():
	#if HERO == true:
		#push_error("before prep for unit" + Unit_Name + "index: " +str(get_index()))
	#increase_damage_to_be_taken(-damage_to_be_taken)
	readied = true
	
	damage_to_be_taken = 0
	besieged_damage = 0
	await check_damage_to_be_taken() 
	straight_target = null

	
func prep_phase():
	#if HERO == true:
		#push_error("prep for unit" + Unit_Name + "index: " +str(get_index()))

	#if Lobby.MULTIPLAYER == true:
		##if Lobby.host == true:
			###curve_rng()
		##else:
		#refresh_my_combat_damage()
	#elif Lobby.MULTIPLAYER == false:
		#refresh_my_combat_damage()
	curve_straight(false)
	
	
################################################################



#func combat_phase():
#	pass
			
			
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

func whats_passive_abilitys_target():
	var Target
	var Ability_target
	if HERO == true:
		Ability_target = AbilitiesDB.HERO_ABILITIES_DB[Identification][AbilitiesDB.TARGPOSITION]
	else:
		Ability_target = AbilitiesDB.CREEP_ABILITIES_DB[Identification][AbilitiesDB.TARGPOSITION]
	if Ability_target == Enums.Targeting.myself:
		Target = self
	else: push_error(" modify whats_passive_abilitys_target(): in Unit1GD pls")
	
	return Target

















	

func _can_drop_data(_at_position, DropData):
	if len(DropData) <4 :
		pass
	#this just checks whether Im accidentaly not hovering 
	#with a unit about to be deployed above a normal state unit
	#THIS MIGHT STOP WORKING IF I ADD ANOTHER DROPDATA WHICH IS ALSO SHORT
			
	else: 
		if Base.current_lane == my_lane or DropData[3] == true:
			#if this is the current lane or the targeting is multilane
			if DropData[0] == "spell" or DropData[0] == "lvlup_spell":
				#if its a spell:
				if DropData[6] == "Hero" and HERO == true and MYrena_rect.Are_heroes_being_played_on == true:
					return true
				elif DropData[6] == "Creep" and HERO == false and MYrena_rect.Are_creeps_being_played_on == true:
					return true
				elif DropData[6] == "Unit" and MYrena_rect.Are_heroes_being_played_on == true:
					return true
			elif DropData[0] == "upgrade" and HERO == true:
				return true
		return false



func _drop_data(_at_position, DropData):
	#DROPDATA SPELL1 THESE: 
	#[0= TYPE, 1=Identification, 2=self.get_index(), 
	#3=crosslane, 4=Card_from_lvlup, 5 = Secondary_targets,
	#6 = Is_played_on, #7 Lobby.current_player]
	
	#DROPDATA ITEM2 THESE: 
	#[0= TYPE, 1=Identification, 2=self.get_index(), 
	#3 = crosslane]
	
	if DropData[0] == "spell" or DropData[0] == "lvlup_spell":
#		print ("spell dropdata: " + str(DropData[0],DropData[1],DropData[2],DropData[3],DropData[4],
#		DropData[5],DropData[6]))
		var DB = SpellsDB
		var DBList = SpellsDB.SPELLS_DB
		if DropData[0] == "lvlup_spell":
			DB = LvlupDB
			DBList = LvlupDB.LVLUPS_DB
			#If the card is from lvlup, we need to change the DB 
			
		if DropData[5] == Enums.Targeting.none:
			hand_rect.hide_used_card(DropData[2])
			var which_function:String = str(DBList[DropData[1]][DB.NAMEPOSITION])
			if Lobby.MULTIPLAYER == true:
				await drop_data_multiplayer_funcall(DropData[0],DropData[1],which_function, DropData[7])
			else:
				await DB.call(which_function,self, DropData[7])
			#Resolves spell effect
			
			hand_rect.consume_hidden_card()
			#Removes the card
			clean_myself_from_effects()
			#cleaning to prevent bs
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
			await tower_layer.unit_targeted_signal(self,DBList[DropData[1]])

			
		elif DropData[5] != Enums.Targeting.none:
			#
			#TEMPORARY SOLUTION I BELIEVE
				#sure bro
			
			var another = COVERING.instantiate()
			#Covering handles the passives here
			if Card_from_lvlup == true:
				another.from_lvlup_card = true
				#This basically transfers the responsibility to deal with 
				#possibly being from different DB to covering
					#???
				
			another.I_want_targets = 2
			another.Card_ID = DropData[1]
			another.My_hand_position = DropData[2]
			another.Secondary_targets = DropData[5]
			UI_layer.add_child(another)
			already_a_target(another)
			
		
	elif DropData[0] == "upgrade":
		#ITEM
		var ID = DropData[1]
		if Lobby.MULTIPLAYER == true:
			item_equipping_multiplayer(ID)
		else:
			equip_item(ID)
		
		#hand_rect.get_child(DropData[2]).queue_free()
		hand_rect.used_card(DropData[2])
#		if MYrena_mid.get_child_count()>0:
#			MYrena_mid.get_child(0).queue_free()
		clean_myself_from_effects()
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		hand_rect.collide_cards()
	
func item_equipping_multiplayer(ID):
	#if Lobby.host == true:
		#card_layer.make_my_mirror_unit_equip_item(ID, MY_UNIQUE_UNIT_KEY)
		#await get_tree().create_timer(Base.FAKE_DELTA).timeout
		#equip_item(ID)
	#else:
		equip_item(ID)
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		card_layer.make_my_mirror_unit_equip_item(ID, MY_UNIQUE_UNIT_KEY)
		
func equip_item(ID):
	play_spammable_sfx(equip_sfx, "equip")
	var Item_type = ItemsDB.ITEMS_DB[ID][ItemsDB.ITEMMPOSITION]
	var Target_slot = self.get_child(Item_type)
	var loaded_item = load("res://Scenes/Items/Item_base.tscn")
	var loaded_script = load("res://Script/ITEMS/" + item_script_folders[Item_type] + ItemsDB.ITEMS_DB[ID][ItemsDB.NAMEPOSITION] +".gd")
	var equipped_item = loaded_item.instantiate()
	equipped_item.set_script(loaded_script)
	equipped_item.Item_ID = ID
	#Item_ID 1
	
	if item_equipped[Item_type] == 0:
		Target_slot.add_child(equipped_item)
		item_equipped[Item_type] = 1
	elif item_equipped[Item_type] == 1:
		Target_slot.get_child(2).being_replaced(equipped_item)
		#because child 0 is Cooldown
	
func drop_data_multiplayer_funcall(spelltype:String, spell_id:int, function_to_be_called:String, current_player:String):
	#can only be called if MP yes
	#handles that join gets the function first, 
		#since curving can't be fucked from there
	var DB = SpellsDB
	if spelltype == "lvlup_spell":
		DB = LvlupDB
			
	#if Lobby.host == true:
		#card_layer.make_mirror_unit_receive_spell_call(spelltype, spell_id, MY_UNIQUE_UNIT_KEY, current_player)
		#await get_tree().create_timer(Base.FAKE_DELTA).timeout
		#DB.call(function_to_be_called,self,current_player)
	#else:
	
	await card_layer.make_mirror_unit_receive_spell_call(spelltype, spell_id, MY_UNIQUE_UNIT_KEY, current_player)
	await DB.call(function_to_be_called,self,current_player)

	
	
	
func _on_slacksus_mouse_entered():
	#	print("MOUSE ENTERED UNIT")
	if (HERO == true and MYrena_rect.Are_heroes_being_played_on == true) or (HERO == false and MYrena_rect.Are_creeps_being_played_on == true):
	#Make an effect only if the dragged card can be played on me
		if MYrena_rect.TargetingSpell == 1:
			Aiming = 1
			SpellEffect_preview()
			
		if MYrena_rect.EquippingItem == 1:
			Iteming = 1
			ItemEffect_preview()

func _on_slacksus_mouse_exited():

#	print("MOUSE LEFT UNIT")
	Aiming = 0
	Iteming = 0
	
	if self.get_child_count()>NATURAL_CHILD_COUNT and Im_targeted == 0 and leveling == 0:
		self.get_child(NATURAL_CHILD_COUNT).queue_free()
#		print(str(self.get_child(4)) + " is gone")

func SpellEffect_preview():
	var caller = "SpellEffect_preview"
#	print("spelleffecting")
	effect_over_hovered_unit(MYrena_rect.TargetingSpell, Aiming, EFFECT, caller)		
		
func ItemEffect_preview():
	var caller = "ItemEffect_preview"
#	print("itemeffecting")
	effect_over_hovered_unit(MYrena_rect.EquippingItem, Iteming, IEFFECT, caller)
	
func effect_over_hovered_unit(_cond1, _cond2, effect, _caller):
	#	while condition1 == 1 and condition2 == 1:    <----BASICALLY THIS 
	
	var population = self.get_child_count()
	if population == NATURAL_CHILD_COUNT:
		var another = effect.instantiate()
#		print("I added the kid again lol")
#		another.position.x = -0
		add_child(another)
#		print("adding")
	elif population == NATURAL_CHILD_COUNT+1:
#		var ETarget = MYrena_mid.get_child(0)
#		ETarget.position.x = self.position.x
#		ETarget.modulate.a = 1
#		print("Effect is chilling")
		pass
	else:
		push_error("Unit has too many children: "+str(self.get_child_count()))
			

	await get_tree().create_timer(Base.FAKE_GAMMA).timeout
	
#	if cond1 == 1 and cond2 == 1 and population == NATURAL_CHILD_COUNT:
#		call(caller)
		#RECURSION TAKE CARE

func already_a_target(calling_targeter):
	clean_myself_from_effects()
	Im_targeted = 1
	calling_targeter.TList.append(self)
	var another = ATEFFECT.instantiate()
	self.add_child(another)
	while Aiming == 1:
		await get_tree().create_timer(Base.FAKE_GAMMA).timeout
		if Im_targeted == 0 and self.get_child_count()>NATURAL_CHILD_COUNT:
			self.get_child(NATURAL_CHILD_COUNT).queue_free()
		
var ConnectionB = 0
func Im_clickable(caller):
	Ability1.disconnect_myself()
	connect("gui_input",_on_ColorRect_input)
	ConnectionB = 1
	Targeter = caller

func Im_no_longer_clickable():
	clean_myself_from_effects()
	Ability1.check_cooldown_penetrability()
	Im_targeted = 0
	Aiming = 0
	leveling = 0
	if is_connected("gui_input", _on_ColorRect_input):
		disconnect("gui_input", _on_ColorRect_input)
		ConnectionB = 0
	Targeter = null
	
var leveling = 0
func show_I_can_lvlup(XP, caller):
	clean_myself_from_effects()
#	print("showing I can lvlup. I need " +str(Lvlup_xp) + " xp")
	if Lvlup_xp <= XP and can_lvlup == true:
		#Hero / nonhero handled in:
		if ConnectionB == 0:
			connect("gui_input",_on_ColorRect_input)
			ConnectionB = 1
#		if leveling != 2:
		leveling = 1
		Ability1.disconnect_myself()
	
		var another = LVLUPEFFECT.instantiate()
		add_child(another)
		Targeter = caller
			
	else: Im_no_longer_clickable()
		
func LVLUP():
	
	
	LEVEL += 1
	leveling = 0
#	Im_no_longer_clickable()
	if is_connected("gui_input", _on_ColorRect_input):
		disconnect("gui_input", _on_ColorRect_input)
		ConnectionB = 0
	
	lvlup_animation()
		
	XP_panel.increase_xp(-Lvlup_xp)
	Targeter.update_XP()
	increase_AttackM(1,true)
	increase_HealthM(1,true)
	await hand_rect.draw_a_lvlup_card(Identification, LVLUP_type)
	card_layer.make_my_mirror_unit_lvlup(MY_UNIQUE_UNIT_KEY)
	
func lvlup_animation():
	var another = LVLUPPING.instantiate()
	send_particle_to_effect_layer(another)
	
func pretend_LVLUP():
	#for opponent heroes
	lvlup_animation()
	
	LEVEL += 1
	leveling = 0
	increase_AttackM(1,1)
	increase_HealthM(1,1)
	hand_rect.scrollh.visualize_drawing_cards_for_opponent(1)
	#currently unrevealed cuz that gonna be long
	
func hide_ability():
	Ability1.hide_myself()
	
func reshow_ability():
	Ability1.reshow_myself()
	
func disconnect_ability():
	Ability1.disconnect_myself()
	
func reconnect_ability():
	Ability1.reconnect_myself()
	
		
func clean_myself_from_effects():
#	print("CLEANING")
	if self.get_child_count()>NATURAL_CHILD_COUNT:
		self.get_child(NATURAL_CHILD_COUNT).queue_free()

func _on_ColorRect_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Base.debugging == false:
			if Im_targeted == 0 and Targeter != null and leveling == 0:
				if event.is_pressed():
					already_a_target(Targeter)
			elif leveling == 1:
				LVLUP()
		else:
			if Base.minus_HPing == true:
				minus_hp()
			elif Base.plus_HPing == true:
				plus_hp()
				



#func curve_rng():
	#var my_slot = get_index()
	#var population = OPrena.get_child_count()
	#var opposer = await get_opposer()
	#
	#
		#
	#if opposer.TYPE == "unit":
		#curve_straight()
		#if Lobby.MULTIPLAYER == true and Lobby.host == true:
			#make_my_mirror_self_curve("straight")
		#
	##there might be a bug if this setting is turned off 
	##which might happen when naturally placing or spawning units
	##bug includes being curved but the arrow not showing it
#
	#else:
		#if Lobby.MULTIPLAYER == false or Lobby.host == true:
			##only the host will calculate curving
			#var random_value = randf()  # Generates a random float between 0 and 1
			#if random_value < 0.4 and my_slot != 0:
			## 42% chance 
				##That looks like 40 bro
				#if OPrena.get_child(my_slot-1) != null and OPrena.get_child(my_slot-1).TYPE == "unit":
					#curve_left()
					#make_my_mirror_self_curve("left")
				#else:
					#curve_straight()
					#make_my_mirror_self_curve("straight")
			#elif random_value >= 0.4 and random_value < 0.8 and my_slot != (population-1):
			## Another 42% chance (totaling 84%)
				#if OPrena.get_child(my_slot+1) != null and OPrena.get_child(my_slot+1).TYPE == "unit":
					#curve_right()
					#make_my_mirror_self_curve("right")
				#else:
					#curve_straight()
					#make_my_mirror_self_curve("straight")
			#else:
			## Remaining 16% chance
				#curve_straight()
				#make_my_mirror_self_curve("straight")
		#elif Lobby.host == false:
			#start_waiting_for_curve_data()


#func make_my_mirror_self_curve(direction):
##	push_error("trying to make_my_mirror_self_curve " +direction)
	##can be "straight" "left" or "right"
	#card_layer.make_mirror_unit_curve(direction, MY_UNIQUE_UNIT_KEY)
	#
#func start_waiting_for_curve_data():
	#push_error("Waiting for curve data")
		
#RNG_curve should probably have its own shit, then we make the annul stuff		
		
#@rpc("any_peer", "call_remote", "reliable")
#func curve_left():
	#targeting = "left"
	##push_error(str(Unit_Name) +" is curving left")
	#%Arrow_combat.curve_left()
	#if OPrena.get_child(get_index()-1).TYPE == "unit":
		#redirect_damage(OPrena.get_child(get_index()-1))
	#else:
		#curve_straight()	
#
##@rpc("any_peer", "call_remote", "reliable")
#func curve_right():
	#targeting = "right"
	##push_error(str(Unit_Name +" is curving right"))
	#%Arrow_combat.curve_right()	
	#if OPrena.get_child(get_index()+1).TYPE == "unit":
		#redirect_damage(OPrena.get_child(get_index()+1))
	#else:
		#curve_straight()
		
#@rpc("any_peer", "call_remote", "reliable")
func curve_straight(call_for_opposer = true):
		#to prevent loop
	
		#to prevent double secondreadying
	
	#targeting = "straight"	
	#%Arrow_combat.curve_straight()
	var opposer = await get_opposer()
	#push_error("opposer type: " + opposer.TYPE + " alive: " +str(opposer.alive))
	#push_error(str(Unit_Name +" is curving straight" + " faction: " +faction + " index: " +str(get_index()) + " opposertype: " + opposer.TYPE))

	if opposer.TYPE == "unit" and opposer.alive == true:
		#redirect_damage(OPrena.get_child(get_index()))
		#push_error("redirecting to a living opposer at " +str(get_index()))
		redirect_damage(opposer)
		
		if call_for_opposer == true:
			opposer.curve_straight(false)
	else:	
		#push_error("didnt curve str opposer type: " +opposer.TYPE + " alive: " +str(opposer.alive))
		redirect_damage(MYrena_rect.OPTower)
	
	my_damage_was_annuled = false
	readied = true
	#was causeing problems when spawning unit to be secondreadied would
		#change it's armor before secondready
		#current sol: reducing armor awaits the readied bool
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
#func ANNUL_curve_left():	
#	var annul_data = [await check_who_to_annul("left")]
#	#already annuls units that need to be
#	#returns them in an array of 2 (might be the same unit)
#	targeting = "left"
#	%Arrow_combat.curve_left()
#	check_who_to_redirect_to_again(annul_data)
#
#
#
#func ANNUL_curve_right():
#	var annul_data = [await check_who_to_annul("right")]
#	#already annuls units that need to be
#	#returns them in an array of 2 (might be the same unit)
#	targeting = "right"
#	%Arrow_combat.curve_right()
#	check_who_to_redirect_to_again(annul_data)
#
#
#func ANNUL_curve_straight():
#	var annul_data = await check_who_to_annul("straight")
#	#already annuls units that need to be
#	#returns them in an array of 2 (might be the same unit)
#	targeting = "straight"
#	%Arrow_combat.curve_straight()
#	check_who_to_redirect_to_again(annul_data)
#
#func check_who_to_annul(curved_into):
#	#this function is used for curving and annuls units who are affected by it
#	var id = get_index()
#	var target_to_be_annuled_1
#	var target_to_be_annuled_2
#
#	print("checking who to anull")
#
#
#
#	match targeting:
#		"straight":
#			target_to_be_annuled_1 = await get_opposer()
#			if target_to_be_annuled_1.TYPE == "void:
#				#we were curved straight and would need to "annul" a tower
#				#that's impossible so:
#				target_to_be_annuled_1.TYPE = MYrena_rect.OPTower #wtf
#				MYrena_rect.OPTower.Im_no_longer_attacked_only_by(self, false, 0)
#				#the '0' there makes it so that I don't lose my damage_used_up_1
#				#since that's how an anull would do it
#		"left":
#			target_to_be_annuled_1 = await get_opposer(id-1)
#			if_no_opposer_reduce_tower_dmg_tbt()
#			#same goes for these, but its straight_attacked
#		"right":
#			target_to_be_annuled_1 = await get_opposer(id+1)
#			if_no_opposer_reduce_tower_dmg_tbt()	
#
#	match curved_into:
#		"straight":
#			target_to_be_annuled_2 = await get_opposer(id)
#			if target_to_be_annuled_2.TYPE == "void:
#				target_to_be_annuled_2 == MYrena_rect.OPTower
#		"left":
#			target_to_be_annuled_2 = await get_opposer(id-1)
#		"right":
#			target_to_be_annuled_2 = await get_opposer(id+1)	
#
#	if 	target_to_be_annuled_1.TYPE == "unit":
#		target_to_be_annuled_1.annul_damage_directed_to_me()
#	elif target_to_be_annuled_1.TYPE == "tower":
#		#if it's a tower 	
#		pass
#		#I don't need to do anything, because if I already was targeting it
#		#the match code already solved it
#	if target_to_be_annuled_1 != target_to_be_annuled_2 and target_to_be_annuled_2.TYPE == "unit":
#		target_to_be_annuled_2.annul_damage_directed_to_me()
#		#target_to_be_annuled_2 can be tower only if it already was dealt with
#		#in target_to_be_annuled_1
#
#	return [target_to_be_annuled_1, target_to_be_annuled_2]
#
#func check_who_to_redirect_to_again(annul_data):
#	#two units"" (could be the same,) 
#	#could be voids
#	#used during curving
#	var prev_target = annul_data[0]
#	var new_target = annul_data[1]
#
#	if prev_target.TYPE == "unit" and new_target.TYPE == "unit":
#		#if they both units:
#		prev_target.redirect_damage_to_me_again()
#		if prev_target != new_target :
#			new_target.redirect_damage_to_me_again()
#
#	if prev_target.TYPE == "tower" and new_target.TYPE == "tower":
#		#if its the tower
#		new_target.Im_attacked_only_by(self,false,0)
#
#	if prev_target.TYPE == "unit" and new_target.TYPE == "tower":
#		#if it was a unit and now its tower
#		prev_target.redirect_damage_to_me_again()
#		new_target.Im_attacked_only_by(self,false,0)
#
#	if prev_target.TYPE == "tower" and new_target.TYPE == "unit":
#		prev_target.Im_straight_attacked_by(self,false,0)
					
#func if_no_opposer_reduce_tower_dmg_tbt():
#	var opposer = await get_opposer()			
#	if opposer.TYPE == "void:
#		MYrena_rect.OPTower.Im_no_longer_straight_attacked_by(self, false, 0)
		
func refresh_my_combat_damage():
	if alive == false: 
		return
	annul_my_damage()
	if Base.Main_phase == 0 and alive == true:
		#match targeting:
			#"left": 
					#curve_left()
			#"straight":
		curve_straight(false)
			#"right":
					#curve_right()
		#push_error("#CURVEREMOVED")
	elif Base.Main_phase == 1: 
	#this was the annul try ig
		#match targeting:
			#"left": 
					#curve_left()
			#"straight":
		curve_straight(false)
			#"right":
					#curve_right()
		#push_error("CURVING STRAIGHTE")
	elif Base.Main_phase == 0 and alive == false:
		pass
		#this happens during game start and causes no problems
	else: push_error("Unknown Base.Main_phase value")
	#lets keep it till a diff is made
	

func refresh_combat_damage_on_me():
	increase_damage_to_be_taken(0)
				
func annul_damage_directed_to_me():
	if alive == false:
		return
	#for calcing armor and so on 
	#var expected_damage = 0
	#var opposer = await get_opposer()
	#if opposer.TYPE == "unit" and opposer.straight_target == self: # and opposer.damage_used_up_1 > 0
		#if opposer.my_damage_was_annuled == false:
		#opposer.my_damage_was_annuled = true
		#push_error("annulling dmgtbt by -" + str(damage_to_be_taken))
	damage_to_be_taken = 0
	check_damage_to_be_taken()
	if besieged_damage > 0:
		card_layer.unit_no_longer_being_sieged(faction, besieged_damage)
		besieged_damage = 0

		
		#expected_damage = opposer.AttackC - ArmorC #opposer.damage_used_up_1
		#if ArmorC > 0 and expected_damage < 0:
			#expected_damage = 0
			#### this check elsewhere
		#if besieged_damage > 0:
			##this means that the opposer is sieging over me
			#expected_damage -= besieged_damage
			##so we can't reduce the whole expected dmg
			#if opposer.AttackC -1 == besieged_damage:
				#expected_damage += ArmorC
		
		#increase_damage_to_be_taken(-expected_damage, false)
		#we are taking care of besieged in increase_damage_to_be_taken() now
		
	
	
	#DONT FORGET TO REDIRECT DAMAGE TO ME AGAIN
	#pls
	
	#if loudness == true:
		#increase_damage_to_be_taken(0)
	
func redirect_damage_to_me_again():
	if alive == false:
		return
	#for calcing armor updates and so on 
	#var id = get_index()
	#var comp = id #-1
	#if comp> -1:
		#var left_opponent = await get_opposer(comp)
		## this crashes push_error("redirect check: " +str(left_opponent.TYPE == "unit") + str (left_opponent.targeting == "right") + str(left_opponent.side_target == self))
		#if left_opponent.TYPE == "unit" and left_opponent.targeting == "right": # and left_opponent.side_target == self
			#left_opponent.my_damage_was_annuled = false
			#left_opponent.side_target = self
			##because I might've landed here and there was someone else b4
			#increase_damage_to_be_taken(left_opponent.damage_used_up_2 - ArmorC,false)
	##FROM THE UNIT TO LEFT
	
	
	#comp = id+1
	#if comp< MYrena_rect.get_child_count():
		#var right_opponent = await get_opposer(comp)
		#if right_opponent.TYPE == "unit" and right_opponent.targeting == "left": # and right_opponent.side_target == self
			#right_opponent.my_damage_was_annuled = false
			#right_opponent.side_target = self
			##because I might've landed here and there was someone else b4
			#increase_damage_to_be_taken(right_opponent.damage_used_up_2 - ArmorC, false)
	##FROM UNIT TO RIGHT
	
	#comp = id
	var opposer = await get_opposer()
	#push_error("redirecting damage to me again")
	if opposer.TYPE == "unit" and opposer.AttackC > 0: # damage_used_up_1and opposer.straight_target == self: 
		opposer.redirect_damage(self)
	check_damage_to_be_taken()
		#opposer.my_damage_was_annuled = false
		#opposer.straight_target = self
		##because I might've landed here and there was someone else b4
			##which would ruin the point of me checking whether opposers straight target is self hmm
		#var expected_damage = opposer.AttackC - ArmorC #damage_used_up_1
		#push_error("expected damage: " + str(expected_damage) + " opp dmg: " +str(opposer.AttackC) + " arm: " + str(ArmorC)) #damage_used_up_1
		#if opposer.Siege == true:  #and opposer.targeting == "straight"
			##this means I was being sieged before I was annuled
			##we have take that into account and recalc besieged dmg and
				##towers dmg to be taken
			#var excess_damage = damage_to_be_taken + expected_damage - HealthC
			#push_error("excess damage: " + str(excess_damage) + " damage_to_be_taken: " +str(damage_to_be_taken) + " HealthC: " + str(HealthC))
			##if excess_damage != besieged_damage:
			##this if has to be skipped due to sieging damage being capped at opposer.AttackC -1
				##if the damage Im supposed to send to tower has changed
			#card_layer.unit_no_longer_being_sieged(faction, besieged_damage)
			#if excess_damage > 0:
				#expected_damage -= excess_damage
				#if opposer.AttackC <= excess_damage:
					#besieged_damage = opposer.AttackC -1
				#else:
					#besieged_damage = excess_damage
				#card_layer.unit_being_sieged(faction, besieged_damage)
		##we are taking care of besieged in increase_damage_to_be_taken() now
		#increase_damage_to_be_taken(expected_damage, false)
			
	#FROM OPPOSER
	
	#THIS IS USED IN COMBINATION WITH ANNUL DAMAGE DIRECTED TO ME

func annul_my_damage(remove_targets_straight_target = false):
	if alive == false:
		return
	#annuls damage that I'm declaring on other units or tower
	
	#remove_targets_straight_target now expands the usage to anull the opposer
		#for anulling presence, since we dont get_opposer in anul_damage_directed_to_me()
		#
	#if my_damage_was_annuled == false:
	if straight_target != null:
		#my_damage_was_annuled = true
		#if side_target	!= null:
			#side_target.Im_no_longer_side_attacked_by(self)
			#straight_target.Im_no_longer_straight_attacked_by(self)
		#else:
		#push_error("annuling damage of " +Unit_Name + " dmg: " +str(AttackC))
		straight_target.Im_no_longer_attacked_only_by(self,Siege)
		if straight_target.TYPE == "unit" and remove_targets_straight_target == true:
			straight_target.straight_target = null
			straight_target.my_damage_was_annuled = true
		straight_target = null
		

	else:
		#push_error("straight target was null during annuling my damage")
		pass
				
	
func redirect_damage(target):
	var opposer = await get_opposer()
	#if HERO == true and opposer.TYPE == "unit":
		#push_error(Unit_Name + " id: " + str(get_index()) + " is redirecting dmg to " + target.Unit_Name)
	
	#if straight_target == null:
		#damage_used_up_1 = 0
	#if side_target == null:
		#damage_used_up_2 = 0
	#I guess it works?
	#makes sure that when creep is gone we don't try to detract damage from them
	#push_error("opposer.TYPE = " + opposer.TYPE)
	#if straight_target != null:
		#push_error("straight_target_type = " + straight_target.TYPE)
	if straight_target == null: # and damage_used_up_1 == 0+damage_used_up_2 
		#first redirection after appearing
		#push_error("straight target null")
		if opposer.TYPE == "unit" and opposer.alive:
			#push_error("curving into opposer")
			#%Arrow_combat.curve_straight()
			#hoply fixes the correct mathly but not graphical curving  
			straight_target = opposer
			straight_target.Im_attacked_only_by(self, Siege)
			#straight_target.curve_straight()
		
		else:
			#push_error("pushing tower")
			straight_target = MYrena_rect.OPTower
			straight_target.Im_attacked_only_by(self, Siege)
			
	elif straight_target.TYPE == "tower" and target == opposer:
		#redirecting from tower to a unit
			straight_target.Im_no_longer_attacked_only_by(self, Siege)
			straight_target = opposer
			straight_target.Im_attacked_only_by(self, Siege)
	elif straight_target == opposer:
		#when redirecting to opposer again (after annullment)
		straight_target.Im_attacked_only_by(self, Siege)
	elif straight_target.TYPE == "tower":
		#when redirecting to tower again (after annullment)
		#push_error("redirecting damage to tower agane")
		straight_target.Im_attacked_only_by(self, Siege)
	elif straight_target.TYPE == "unit" and opposer.TYPE == "unit":
		#straight_target.Im_no_longer_attacked_only_by(self, Siege)
		straight_target = opposer
		straight_target.Im_attacked_only_by(self, Siege)
	
			
	else:	#when ignoring opposer
		push_error("ignoring opposer id: " + str(get_index()))
		straight_target = MYrena_rect.OPTower
		straight_target.Im_attacked_only_by(self, Siege)
			
			
	#in case the unit just appeared
	
	#if damage_used_up_2 == 0:
		##curving from attacking tower or the unit straight across only
		#if target == straight_target:
##			print("curving from attacking tower or the unit straight across only")
			#straight_target.Im_no_longer_attacked_only_by(self,Siege)
			#straight_target.Im_attacked_only_by(self, Siege)
			#
			##if we are curved into same target again, refresh damage
			#
		#elif target.TYPE == "tower":
			##We assume that the opposer was the previous target and is dead 
			##and redirect damage was triggered outside of prephase
			##for example during cleanup phase
			#
			##well now that we have creeps we have to take them into account:
			#if straight_target != null:
##				push_error("well now that we have creeps we have to take them into account:")
				##I have no idea what this does, but it works
				#straight_target.Im_no_longer_attacked_only_by(self,Siege)
			#
			#damage_used_up_1 = 0
			##may not be able to call the Im no longer attackedx the prev target
			##so just set it to 0, since we werent curved before this
			#
			#straight_target = target
			#straight_target.Im_attacked_only_by(self, Siege)
			#
			#
		#else:
			#straight_target.Im_no_longer_attacked_only_by(self,Siege)
			##removes the pointing damage
##			print("removes the pointing damage")
			#if target == opposer:
				##We were attacking tower previously
				#straight_target = target
				#straight_target.Im_attacked_only_by(self, Siege)
			#else:
			##if target isnt opposer then we curved
			##or its tower, dummy (already fixed)
				#straight_target.Im_straight_attacked_by(self)
				##the target should modify my damage used up 
				##adds half the damage to tower
				#
				##side_target = target
				##side_target.Im_side_attacked_by(self)
				#
			##there will be different function along the lines of "update direction of dmg" for when a unit appears in front of me
		#
		#
	#elif damage_used_up_2 != 0:
		##curving from already being curved to a side unit
		#if target == side_target:
			## if we are still curved into the same target, refresh dmg
			#side_target.Im_no_longer_side_attacked_by(self)
			#side_target.Im_side_attacked_by(self)
##			print("it was side")
			#
			##straight_target_also has be refreshed, 
			##because we may have just equipped an item
			#straight_target.Im_no_longer_straight_attacked_by(self)
			#straight_target.Im_straight_attacked_by(self)
			#
			#
			#
		#elif straight_target.TYPE == "unit" and target == opposer:
##			print("it was opposer")
			##if we are curved to attack straight
			#side_target.Im_no_longer_side_attacked_by(self)
			#straight_target.Im_no_longer_straight_attacked_by(self)
			##remove the damage 
			#side_target = null
			#straight_target.Im_attacked_only_by(self, Siege)
			#
		#elif straight_target.TYPE == "tower" and (target == opposer or target == straight_target):
			##we were curved to side and there was empty slot across us, 
			##a unit appeared there and we target it now or the tower
			#side_target.Im_no_longer_side_attacked_by(self)
			#side_target = null
			#straight_target.Im_no_longer_straight_attacked_by(self)
			#straight_target = target 
			#straight_target.Im_attacked_only_by(self, Siege)
#
			#
		#else: #if we are curved into the other side unit
##			print("it was else")
			#side_target.Im_no_longer_side_attacked_by(self)
			#side_target = target
			#side_target.Im_side_attacked_by(self)
			
func Im_attacked_only_by(attacker, _attackers_siege):
	var dmg = attacker.AttackC
	#attacker.damage_used_up_1 = dmg
	var expected_damage = dmg - ArmorC
#	if attackers_siege == true:
#		var overkill_damage = damage_to_be_taken + expected_damage - HealthC
#		if overkill_damage > 0:
#			card_layer.unit_being_sieged(faction, overkill_damage)
#			expected_damage -= overkill_damage
#			besieged_damage = overkill_damage
	#we are taking care of besieged in increase_damage_to_be_taken() now
	if dmg >= 0 and expected_damage < 0:
		expected_damage = 0
	if dmg<=0 and expected_damage > 0:
		expected_damage = 0
	#armor shenanigans
	#if HERO == true or attacker.HERO == true:
		#push_error(Unit_Name + " id: " + str(get_index()) + " is attacked only by " + attacker.Unit_Name)

	increase_damage_to_be_taken(expected_damage)
	
	
		
func Im_no_longer_attacked_only_by(attacker, _attackers_siege):
	#push_error("unit " +Unit_Name +" id: " +str(get_index()) + " is nolongerattkedonlyby " + attacker.Unit_Name)
	#var dmg = attacker.damage_used_up_1
	var dmg = attacker.AttackC

	if dmg > 0:
		#attacker.damage_used_up_1 = 0
		var expected_damage = dmg - ArmorC
		
		if dmg >= 0 and expected_damage < 0:
			expected_damage = 0

		#armor shenanigans
		if _attackers_siege == true:
			expected_damage -= besieged_damage
			card_layer.unit_no_longer_being_sieged(faction,besieged_damage)
			if attacker.AttackC -1 <= besieged_damage:
				expected_damage += ArmorC
				#negative armor shenanihanz
			besieged_damage = 0
		
		increase_damage_to_be_taken(-expected_damage) 
	
	
#func Im_no_longer_side_attacked_by(attacker):
	#var dmg = attacker.damage_used_up_2
	#if dmg > 0:
		#attacker.damage_used_up_2 = 0
		#var expected_damage = -dmg + ArmorC
		#
		#if dmg > 0 and expected_damage > 0:
			#expected_damage = 0
		#increase_damage_to_be_taken(expected_damage) 
		#
#func Im_no_longer_straight_attacked_by(attacker):
	#var dmg = attacker.damage_used_up_1
	#attacker.damage_used_up_1 = 0
	#var expected_damage = -dmg + ArmorC
	#
	#if dmg > 0 and expected_damage > 0:
		#expected_damage = 0
	#increase_damage_to_be_taken(expected_damage) 
	#
	
	
func ignore_opposer():
	#push_error(str(Unit_Name) + " is ignoring opposer at " +str(get_index()))
	#used when a unit dies in front of me
	#this is called before the unit dies so that I can target the tower
	#because I don't know how to call it after it's death
		#actually just don't wanna do it now
	#if targeting == "straight":
#		print("it was curved straight")
	#damage_used_up_1 = 0
	if Siege == true and straight_target != null and straight_target.TYPE == "unit":
		card_layer.unit_no_longer_being_sieged(straight_target.faction, straight_target.besieged_damage)

	
	var target = MYrena_rect.OPTower
	straight_target = target
	
	redirect_damage(target)
		
	#else: 
#		print("it was curved to the side")
		#damage_used_up_1 = 0
		#var target = MYrena_rect.OPTower
		#straight_target = target
		#
		#redirect_damage(target)
	
		

func increase_damage_to_be_taken(amount, check_for_siege = true): 
	#ddd
	var problem = false
	#for debugging
	
	damage_to_be_taken += amount 
	var opposer = await get_opposer()
#	var preopposer = await get_opposer()
#	if opposer.TYPE == "unit" and opposer.Siege == true:
	#wtf is preopposer
	
	if problem == true:
		push_error(" increasing dmg tbt by: " +str(amount) +" " + str( damage_to_be_taken) +" " + str( besieged_damage) + " " +str(get_index()) + " " +str(faction) )
	#Oh nyo, welcome back again master 
	
	
	if check_for_siege == true: 
		#only set to false when this is called from the anull guys
		

		damage_to_be_taken += besieged_damage 
		if alive == true and damage_to_be_taken >= 0:
			overkill_damage =  damage_to_be_taken - HealthC 
			#otherwise dying unit recalcs overkill damage
		if alive == true and damage_to_be_taken < 0:
			#this means that a unit that inflicted so much damage onto
				#me that it would oneshot me died and siege is fucked
			damage_to_be_taken += overkill_damage 
			#this can only happen when subtracting dmgtbtkn 
				#gotta divide this function into adding and subtracting
			card_layer.unit_no_longer_being_sieged(faction, overkill_damage)
			overkill_damage = 0
			
		var being_sieged = false 
		#if problem == true:
			#push_error("overkill dmg: " +str(overkill_damage))
		if overkill_damage > 0:
			
			if opposer.TYPE == "unit" and opposer.Siege == true : #and opposer.targeting == "straight"
			#check whether tower is gonna take siege damage
				being_sieged = true
				if besieged_damage > 0:
					card_layer.unit_no_longer_being_sieged(faction, besieged_damage)
				#if I was already besieged, retract that number
				if opposer.AttackC <= overkill_damage:
					#happens when armor goes bellow 0
					#at least 1 dmg has to be consumed to kill the opposer
					besieged_damage = opposer.AttackC -1
					damage_to_be_taken = HealthC
				else:
					besieged_damage = overkill_damage
					damage_to_be_taken-= overkill_damage
				#to visually se only how much Im absorbing
				#push_error("besieged damage: " +str(besieged_damage) + " overkill_damage: " + str(overkill_damage))
				card_layer.unit_being_sieged(faction, besieged_damage)
				#update besieged damage and send it over
				
			else:
				overkill_damage = 0
				#so that it doesnt mess up next calc

		if besieged_damage> 0 and being_sieged == false:
			#this only happens if overkill is 0, so that's kept
			#could cause problems if opposer qufreed early
				#quefreeing early solved with: 'if alive == true and damage_to_be_taken < 0:'
			card_layer.unit_no_longer_being_sieged(faction, besieged_damage)
			besieged_damage = 0
			#I might've been sieged previously, retract that if no longer
	else:
		push_error("not checking for siege")	
	%DMG_TBT.text = str(damage_to_be_taken)
	check_damage_to_be_taken()		
	#modifies deathmarker
	#if problem == true:
		#push_error(" final increased dmg tbt by: " +str(amount) +" " + str( damage_to_be_taken) +" " + str( besieged_damage) + " " +str(faction))


func check_damage_to_be_taken():
	if damage_to_be_taken >= HealthC:
		show_incoming_death()
	else:
		hide_incoming_death()
	if damage_to_be_taken == 0:
		%DMG_TBT.self_modulate.a = 0
	else:
		%DMG_TBT.self_modulate.a = 1
		%DMG_TBT.text = str(damage_to_be_taken)
	


func show_incoming_death():
#	%DEATH.visible = true
	%DEATH.modulate.a = 0.75
	var death_material : ShaderMaterial = ShaderMaterial.new()
	death_material.shader = death_shader
	%UNIT_JPEG.material = death_material
	
	
func hide_incoming_death():
#	%DEATH.visible = false
	%DEATH.modulate.a =	0
	%UNIT_JPEG.material = null




func lane_aura_check():
	#push_error("lane_aura_check_at_me")
	%Lane_auras.reupdate(faction)
	#push_error("lane_aura_checking")
	




func connect_my_passive_trigger(_AbilityNode, _PassiveTrigger):
#	var function_to_call = str(PassiveTrigger)+"_list"
	pass
	#???wtf





func enter_draggable_state():
	#for when a hero respawns to be able to drag it to deploy it
	%DraggingRect.visible = true
#	push_error("entering draggable state " + str(MY_UNIQUE_UNIT_KEY))
	
	#should be enough?
	
func leave_draggable_state():
	%DraggingRect.visible = false


func new_lane():
	#when a unit is moved to a new lane, these need to be updated
	var old_lane = my_lane
	await refresh_my_lane_int()
	#if old_lane != my_lane:
		#this if is obsolete, since tower layer can remove you from it's array when ur dead
		
	if Passiveness == true and has_ability == true:
		await Ability1.get_child(2).remove_myself_from_old_array(tower_layer)
	
	card_layer = $"../../../../.."
	tower_layer = $"../../../../../../Tower_layer"
	tower_mana = $"../../../../../../Tower_layer/TowerA/Mana_display/Current_mana"
	MYrena_rect = $".."
	OPrena = MYrena_rect.OPrena_rect
	
	
	
	if Passiveness == true and has_ability == true:
		#push_error("ability shit part of newlane is trigging")
		await Ability1.get_child(2).new_lane(tower_layer)
	#this connects the unit to the correct signal hub
		#child 2 of ability is the one that is created during ready
	#push_error("newlane completed for " + Unit_Name + str(my_lane))
	
	
	


func refresh_my_lane_int():
	#divided into two functions just so that I don't have to load 4 pointless
	#nodes on each raedy_function of unit twice
	which_lane  = $"../../../../../.."
	match which_lane.name:
		"First_lane":
			my_lane = 1
		"Mid_lane":
			my_lane = 2
		"Last_lane":
			my_lane = 3
	#just int doesnt work with nodes but crosslane stuff
	return 0
	#awaiterer
	
func appear_dead():
	alive = 0
	%Arrow_combat.visible = 0
	%Ability_field.visible = 0
	
func appear_alive():
	alive = 1
	%Arrow_combat.visible = 1
	%Ability_field.visible = 1

func get_opposer(Index = get_index()):
	#I cant add an incorect argument check here because it wouldnt get to while loop
	#which would ruin the primary purpose of this function
	var opposer = OPrena.get_child(Index)
#	var mb_opposer
	while opposer == null or (Base.Main_phase == 0 and opposer.TYPE == "unit" and opposer.alive == false):
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		if MYrena_rect.get_child_count() == OPrena.get_child_count():
			#testing this to solve problem where last slot A 
			#becomes second to last due to bonus void in B (spawning)
			opposer = OPrena.get_child(Index)
		#push_error("still waiting for opposer at: " + str(Index))

	return opposer
		
	#WARNING EXPERIMENTAL SOLUTION	
	
	#at least it doesnt crash and I can see where the problem at, nice
	#not like I can fix it though lule

func I_have_position_aura():
	has_position_aura = true
	MYrena_rect.has_position_aura_array.append(self)
	
	
	
func annul_my_presence():
	await annul_damage_directed_to_me() 	
	await annul_my_damage(true)
	
#func cleanse_me_from_position_auras():
	#for i in %Position_auras.get_child_count():
		#%Position_auras.get_child(i-1).get_removed()
	
func pull_me_out_of_this_lane():
	var my_index = get_index()
	await remove_position_and_lane_auras()
	await annul_my_presence()
	
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	#the damage2 doesn't seem to be annulled soon enough
	
	self.reparent(D12)
	
	MYrena_rect.insert_void(my_index)
	
	tower_layer.unit_order_changed_signal(my_lane)
	await OPrena.refresh_annulled_units()
	MYrena_rect.maybe_clean_two_voids(my_index)
	#has to be here so that if I was targeting left and that unit left, 
		#if it had opposer void, I should now curve straight
		#which I'm checking by whether there is a unit as my left-target

func remove_position_and_lane_auras():
	push_error("removing position and lane auras")
	for i in range(lane_auras.get_child_count()-1, -1,-1):
		await lane_auras.get_child(i).get_removed()
		push_error("auranumber: " +str(i))
		
	push_error("lane auras removed")	
	for i in range(position_auras.get_child_count()-1,-1,-1):
		await position_auras.get_child(i).get_removed()	
		push_error("auranumber: " +str(i))
		
	push_error("position auras removed")
		
	await get_tree().create_timer(Base.FAKE_DELTA).timeout	
		
#func refresh_me_from_being_annulled():
	#if my_damage_was_annuled == false:
		#push_error("unit forced to be refreshed_from_being_annulled despite not being annulled")
	#else:
##		var opposer = await get_opposer()
		##var my_index = get_index()
		###var target
		###if targeting == "straight": #and opposer.TYPE == "void: #notsure if needed
		##straight_target = null
			#
		##CLEARING TWO VOIDS WASNT CALLED YET
		##elif targeting == "left":
			##if my_index > 0:
				##target = await get_opposer(my_index-1)
				##if target.TYPE == "void":
					##side_target = null
			##else:
				##push_error("I was curved to left despite being id0 ")
		##elif targeting == "right":
			##if my_index > 0:
				##target = await get_opposer(my_index+1)
				##if target.TYPE == "void":
					##side_target = null
			##else:
				##push_error("I was curved to left despite being id0 ")
		##else: push_error("unknown targeting found in refresh_me_from_being_annulled: " +str(targeting))
		#
		##refresh_my_combat_damage()	
		#curve_straight()	
	#
	
func get_visual_center():
	visual_center = global_position + Vector2(0.0,Base.head_offset)
	return visual_center
	
func hide_ability_and_items_mb():
	#sets mouse filter to ignore, used when targeting units
	hide_ability()
	if HERO == true:
		%weapon_slot.hide_myself()
		%special_slot.hide_myself()	
		%armor_slot.hide_myself()
		
func reshow_ability_and_items_mb():
	reshow_ability()	
	if HERO == true:
		%weapon_slot.reshow_myself()
		%special_slot.reshow_myself()	
		%armor_slot.reshow_myself()
	
func disconnect_ability_and_items_mb():
	disconnect_ability()
	if HERO == true:
		%weapon_slot.disconnect_myself()
		%special_slot.disconnect_myself()	
		%armor_slot.disconnect_myself()
		
func reconnect_ability_and_items_mb():
	reconnect_ability()	
	if HERO == true:
		%weapon_slot.reconnect_myself()
		%special_slot.reconnect_myself()	
		%armor_slot.reconnect_myself()
	
func decrease_item_cooldowns():
	%weapon_slot.decrease_cooldown()
	%special_slot.decrease_cooldown()
	%armor_slot.decrease_cooldown()


func check_cooldown_penetrability():
	Ability1.check_cooldown_penetrability()
	%weapon_slot.check_cooldown_penetrability()
	%special_slot.check_cooldown_penetrability()
	%armor_slot.check_cooldown_penetrability()

func force_remove_myself_from_trigger_array():
	#only called when unit is being transfered from arena_rect to spawner
	#+ when from arenarect to grave transfer
		#so I have to make their 'my_lane' 4 so that they remember to reconnect
		#HERE this might break something
	my_lane = 4	 
	if Passiveness == true and has_ability == true:
		Ability1.get_child(2).remove_myself_from_old_array(tower_layer)


#func calc_particle_holder_scaled_position():
	#the problem had to be somewhere else, dunno where
		#"solved" by adding effecter node in Lvlupping_effect.tscn
	#var real_position = particle_holder.global_position
	#var space_l = real_position - SCROLLA.global_position
	#var space_r = real_position - space_l
	#var result = space_l + (Base.SCROLLA_SCALE * space_r)
	##return result
	#return particle_holder.global_position

#var current_spammable_sfx:String = ""
func play_spammable_sfx(loaded_sfx, sfx_name):
	var new_sfx = AudioStreamPlayer2D.new()
	particle_holder.add_child(new_sfx)
	new_sfx.stream = loaded_sfx
	new_sfx.play()
	#current_spammable_sfx = sfx_name
	new_sfx.finished.connect(_on_new_sfx_base_finished.bind(new_sfx, sfx_name))

func _on_new_sfx_base_finished(sfx_node: AudioStreamPlayer2D, sfx_name: String) -> void:
	if sfx_name in Base.spammable_sfx:
		Base.spammable_sfx.erase(sfx_name)
	sfx_node.queue_free()


#######################################################################
### 						ANIMATIONS 								###
#######################################################################

func particle_holder_based_animation(caller_name:String):
	#animations "Inside card_layer area of the screen" -> SCROLLA Scaling
	animating = true
	var animation_scene = load("res://Scenes/VFX/" +caller_name + "_vfx.tscn")
	var another = animation_scene.instantiate()
	if another != null:
		send_particle_to_effect_layer(another)
		while animating:
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
	else:
		push_error("null caller name: " +caller_name)
		
func UI_layer_based_animation(caller_name:String):
	#whole screen animations -> NO SCROLLA scaling
	animating = true
	var animation_scene = load("res://Scenes/VFX/" +caller_name + "_vfx.tscn")
	var another = animation_scene.instantiate()
	if another != null:
		another.wielder = self
		UI_layer.add_child(another)
		while animating:
			await get_tree().create_timer(Base.FAKE_DELTA).timeout
	else:
		push_error("null caller name: " +caller_name)
		
		
func move_z_forward():
	z_index += 1
func move_z_backwards():
	z_index -= 1
#used to move me to top when I'm moved eg to middle of screen
func dont_flinch():
	flinching = false
func flinch_again():
	flinching = true
	
	
func send_particle_to_effect_layer(another:Node):
	another.wielder = self
	another.global_position = particle_holder.global_position
	another.scale = Base.SCROLLA_SCALE
	effect_layer.add_child(another)

func SMASH(wait_for_backing:bool = true):
	#include backing can be skipped when casting duel
	animating = true
	var prep_time = 0.25
	var charge_time = 0.1
	var back_time = 0.4
	var x = self.position.x
	var y = self.position.y
	var prep_distance = 210
	var charge_distance = 240
	if faction == "beta":
		prep_distance = -prep_distance
		charge_distance = -charge_distance
	
	var tween = get_tree().create_tween()
	#we tween property 	of what 	which one 	to what 			how much time
	tween.tween_property(self, "position", Vector2(x,y+prep_distance), prep_time)
	tween.tween_property(self, 
	"position", Vector2(x,y+prep_distance-charge_distance), charge_time)
	await tween.finished
	var tween2 = get_tree().create_tween()
	if wait_for_backing: 
		push_error("backing")
		tween2.tween_property(self, "position", Vector2(x,y), back_time)
		await tween2.finished
		animating = false
	else:
		tween2.tween_property(self, "position", Vector2(x,y), back_time)
		animating = false


#var VDAL = card_layer.visible_card_layer.death_anim_length
var mid_damage = 11.0
var DM = 1 #Direction modifier
func death_animation(DMG):
	if MYrena_rect.MY_identity == "B":
		# "B" Means we are in Abarena
		DM = -1
	var push_modifier = 0.6 + DMG/mid_damage
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position",Vector2(0,300*push_modifier*DM),
	 Base.death_anim_length).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "modulate:a", 0, Base.visible_death_anim_length)
	tween.tween_property(self,
	"rotation_degrees", -15, Base.death_anim_length).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)

func getting_hit_animation():
	if animating or not flinching: 
		return
	if MYrena_rect.MY_identity == "B":
		# "B" Means we are in Abarena
		DM = -1
	var y_distance = 20
	var anim_angle = -5
	var neutral_color = Color(1.0, 1.0, 1.0, 1.0)
	var target_color = Color(1.0, 0.7, 0.7, 0.85)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position",Vector2(0,y_distance * DM),
	 Base.hit_anim_length).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "modulate", target_color, Base.hit_anim_length)
	tween.tween_property(self,
	"rotation_degrees", anim_angle, Base.hit_anim_length).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	await tween.finished
	var tween2 = create_tween().set_parallel(true)
	tween2.tween_property(self, "position",Vector2(0,y_distance * DM * -1),
	 Base.hit_anim_length).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween2.tween_property(self, "modulate", neutral_color, Base.hit_anim_length)
	tween2.tween_property(self,
	"rotation_degrees", -anim_angle, Base.hit_anim_length).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)

func debuff_applied_animation():
	particle_holder_based_animation("Debuff_applied")

func buff_applied_animation():
	particle_holder_based_animation("Buff_applied")

func heal_applied_animation():
	particle_holder_based_animation("Heal")
	
var stat_sca_counts = {
	"HealthC": 0,
	"AttackM": 0,
	"ArmorM": 0 }
#to move the sca a bit higher to not cover simultaneous changes

func stat_change_animation(changed_stat:String, change_amount:int):
	#push_error("stat_change_animation, stat: " + changed_stat + ", amount: " + str(change_amount))
	if change_amount == 0:
		return
	var target_stat_position:Vector2
	match changed_stat:
		"HealthC":
			target_stat_position = %HP.global_position - particle_holder.global_position
		"AttackM": 
			target_stat_position = %ATK.global_position - particle_holder.global_position
		"ArmorM" :
			target_stat_position = %AR.global_position - particle_holder.global_position
	stat_sca_counts[changed_stat] += 1
	#push_error("global position: " + str(target_stat_position))		
	var another = stat_change_visual.instantiate()
	another.global_position = particle_holder.position
	another.target_stat_position = target_stat_position
	another.stat_change_value = change_amount
	another.simultaneous_position = stat_sca_counts[changed_stat]
	another.wielder = self
	effect_layer.add_child(another)
	await get_tree().create_timer(another.tween_duration).timeout
	stat_sca_counts[changed_stat] -= 1

#######################################################################
### 						Debug functions						###
#######################################################################

func minus_hp(mirror = true):
	#mirror set to false only when receiving rpc to not loop
	increase_HealthC(-1)
	if mirror == true:
		card_layer.make_my_mirror_minus_hp(MY_UNIQUE_UNIT_KEY)
		
func plus_hp(mirror = true):
	increase_HealthC(1)
	if mirror == true:
		card_layer.make_my_mirror_plus_hp(MY_UNIQUE_UNIT_KEY)
