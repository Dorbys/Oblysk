extends TextureRect

#@export var no_action_warning: PackedScene


@onready var UI_layer = $"../../../../../../../../../UI_layer"

@onready var Card_layer = $"../../../../../../../"
@onready var wielder = $"../.."

@onready var camera_for_tooltip = $"../../../../../../../../../Camera2D"
#this has to be specified for every parent of node that will have a tooltip

var	COOLDOWN_SHADED = 0.35
var COOLDOWN_OFF = 1


var ConnectionT = 0

var CooldownM
var CooldownC

var connection_to_passive 
#for kimmedi lol

var passiveness
var text_for_tooltip = "tooltip didn't load properly"


## Called when the node enters the scene tree for the first time.
func _ready():
#	hide_myself()
	
	if wielder.has_ability == false:
		visible = false
	

		
	
func Im_active_and_ready():
	var wielders_description_name = wielder.Unit_Name + "_ability_description"
	text_for_tooltip  = AbilitiesDB[wielders_description_name]
	passiveness = false
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	#I guess this would've loaded before Ability cooldown is transfered from unit
	#since this is called on ready() of Unit
	await activate_cooldown()
	reshow_myself()
	
	#current theoretical: starting cooldowns are 1 bellow max
	decrease_cooldown()
		
func Im_passive_and_ready():
	passiveness = true
	%Cooldown.visible = false
	
	
	
func activate_cooldown(_rpced = false):
	CooldownC = CooldownM
	%Cooldown.text = str(CooldownC)
	make_cooldown_shaded()
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout
	#Else I will target my wielder because of ignoring the input event of click
	hide_myself()
	#test this with targeting abilities
	%Ability_field.mouse_default_cursor_shape = CURSOR_ARROW
	
	
	await get_tree().create_timer(Base.FAKE_GAMMA).timeout
	reshow_myself()
	#for tooltip visibility
	
	if Lobby.MULTIPLAYER == true and _rpced == false and wielder.readied == true and Base.game_started_yet_bruh:
		# readied check to prevent startup problems
			# same reason for game_started_yet_bruh
		wielder.card_layer.mirror_ability_activate_cooldown(wielder.MY_UNIQUE_UNIT_KEY)
		


func decrease_cooldown():
	if CooldownC != null:
		#push_error("decreasing cooldown")
		CooldownC -= 1
		if CooldownC < 0:
			CooldownC = 0
		if CooldownC == 0:
			make_cooldown_off()
			reshow_myself()
		%Cooldown.text = str(CooldownC)
	else:
		push_error("Attempted to decrease null cooldown")

func make_cooldown_shaded():
#	material.set_shader_parameter("Is_cooldown_ready", COOLDOWN_SHADED)
	disconnect_myself()
	self_modulate = Color(0.5,0.5,0.5)
	%Cooldown.self_modulate.a = 1
	
func make_cooldown_off():
#	material.set_shader_parameter("Is_cooldown_ready", COOLDOWN_OFF)
	reconnect_myself()
	#starts disconnected
	self_modulate = Color(1,1,1)
	%Cooldown.self_modulate.a = 0





	
func _on_ability_field_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				var action_check = wielder.UI_layer.does_player_have_action()
				if action_check == true:
					#print("ABILITY 1 CLICKED")
	#				%Ability_field.MOUSE_FILTER_STOP
					#So that card doesnt automatically select itself as TList[0]
						#No longer needed, no fucking idea why, but it works
					var AID = wielder.Identification
					if AbilitiesDB.HERO_ABILITIES_DB[AID][AbilitiesDB.TARGPOSITION] != Enums.Targeting.myself:
					#we only need covering if there is something to be targeted
						var another = wielder.COVERING.instantiate()

						if AbilitiesDB.HERO_ABILITIES_DB[AID][AbilitiesDB.TARGPOSITION] == Enums.Targeting.one_unit:
							another.I_want_targets = 1
						else: push_error("I_Want_targets for this targeting wasnt automated yet")
						
						another.origin_ability = self
						another.Ability_ID = AID
						UI_layer.add_child(another)
						Im_looking_for_targets_visual()
						await get_tree().create_timer(Base.FAKE_GAMMA).timeout
						hide_myself() #needed with the delay else selftargetting
					else:
						AbilitiesDB.call(str(AbilitiesDB.HERO_ABILITIES_DB[AID][AbilitiesDB.NAMEPOSITION]),wielder)
						activate_cooldown()
						#if we don't have covering we take care of CD manually
						if Lobby.MULTIPLAYER == true:
							Base.pass_the_initiative()
					
					%Ability_field._mouse_exited()
				else:
					UI_layer.you_dont_have_action()
				
func disconnect_myself():
	if ConnectionT == 1:
	#Because I have no idea how to check wheter its DISCONNECTED
		%Ability_field.disconnect("gui_input", _on_ability_field_gui_input)
		%Ability_field.mouse_default_cursor_shape = CURSOR_ARROW
		ConnectionT = 0

func reconnect_myself():
	
	if passiveness == false and ConnectionT == 0 and wielder.faction == "alpha":
		push_error("reconnecting because: ")
		#Because I have no idea how to check wheter its DISCONNECTED
		%Ability_field.connect("gui_input", _on_ability_field_gui_input)
		%Ability_field.mouse_default_cursor_shape = CURSOR_POINTING_HAND
		ConnectionT = 1
		
func hide_myself():
	#push_error("ability hiding")
	#Is now hiding Ability_field because that carries the tooltip
		#self is now always ignoring
#	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
#	#THIS NECCESARY WHEN TEXTURE ISNT THE SAME AS IN THE SCENE
#		#But not in every case wtf
##	print(self.mouse_filter)
#	push_error("Hiding ability through: ")
	%Ability_field.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#THIS ENOUGH WHEN THE TEXTURE DOESNT CHANGE
	
func reshow_myself():
	#push_error("ability reshowing")
	#if CooldownC == null or CooldownC < 1:
	#this no longer needed?
	
#		self.mouse_filter = Control.MOUSE_FILTER_STOP
			#Is now hiding Ability_field because that carries the tooltip
				#self is now always ignoring
	%Ability_field.mouse_filter = Control.MOUSE_FILTER_STOP
		
		
func Im_looking_for_targets_visual():
	Card_layer.ability_is_looking_for_targets_visual()
	
	
func check_cooldown_penetrability():
	if passiveness == false and CooldownC < 1:
		if Base.current_lane == wielder.my_lane:
			reconnect_myself()
		else:
			disconnect_myself()
			

		
