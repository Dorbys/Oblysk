extends Control

@onready var tower_layer = $"../../../../../../../../../Tower_layer"
@onready var wielder = $"../../.."

var ARMOR = 1
var DAMAGE = 5
var INCREMENT = 3
var description = "Adjecent enemies have -" +str(ARMOR) +" armor.
Monday: I deal " + str(DAMAGE) + " physical damage to enemy tower and increase my damage by " +str(INCREMENT)

func _ready():
	wielder.Ability1.text_for_tooltip = description
	tower_layer.monday_phase_list.append(self)
	tower_layer.unit_order_changed_array.append(self)
	await get_tree().create_timer(0.2).timeout 
	aura_unique_id = Base.aura_unique_id
	Base.increase_aura_unique_id()
	wielder.I_have_position_aura()
	#takes care of pos_aura array in arenarect and binary var
	aura_affect_primary_targets()
	

func new_lane(new_tower_layer):
	if self not in new_tower_layer.monday_phase_list:
		new_tower_layer.monday_phase_list.append(self)

func monday_phase():
	Sommelier()
		
func Sommelier():
	wielder.MYrena_rect.OPTower.take_damage(DAMAGE)
	DAMAGE += 3
	refresh_my_aura()
	description = "Adjecent enemies have -" +str(ARMOR) +" armor.
Monday: I deal " + str(DAMAGE) + " damage to enemy tower, increase damage by " +str(INCREMENT)
	wielder.Ability1.text_for_tooltip = description
	
	
	
	
###############################################################
#################3	 		AURA PART			###############
###############################################################	
	
var affects = "enemies"
#allies enemies both	
#might not be necc since I dont rly have a scene script
var aura_name = "Acid11"
var aura_unique_id
#set in ready()

	
	
func do_I_affect_this(target):
	if target.TYPE == 0 and abs(target.get_index()-wielder.get_index())<= 1:
		return true
	else: return false
	
func aura_affect_primary_targets():
	var id = wielder.get_index()
	var population = wielder.MYrena_rect.get_child_count()
	var target
	var comp_id
	for i in 3:
		comp_id = id-1+i
		if comp_id < 0 or comp_id >= population:
			continue
		target = await wielder.get_opposer(comp_id)
		if do_I_affect_this(target) == true:
			target = target.position_auras
			affect_unit(target)
	
	
	
	
func affect_unit(target):
	#target is the auraslot already
#	print("AFFECTING")
	if target.has_node(aura_name+str(aura_unique_id)) == false:
		var aura_effect = Control.new()
		aura_effect.name = aura_name+str(aura_unique_id)
		var aurascript = load("res://Script/AurasFromBuildingsList/" +aura_name + ".gd")
		aura_effect.set_script(aurascript)
		target.add_child(aura_effect)	
	
	
func refresh_my_aura():
	var population = wielder.MYrena_rect.get_child_count()
	var wielders_id = wielder.get_index()
	var OPrena = wielder.MYrena_rect.OPrena_rect
	var target
	for i in range(population-1,-1,-1):
		target = OPrena.get_child(i)
		if target != null and target.TYPE == 0:
			if abs(target.get_index()-wielders_id) <2:
			#divided into two parts because UNITS that are affected by me
			#but should no longer be have to get their auraeffect removed
				affect_unit(target.position_auras)
			else:
				printerr("checking for: " + aura_name +str(aura_unique_id))
				if target.position_auras.has_node(aura_name+str(aura_unique_id)):
					target.position_auras.get_node(aura_name+str(aura_unique_id)).get_removed()
	
	
func unit_order_changed():
	if wielder.alive == 1:	
		refresh_my_aura()
	
func remove_aura_on_death():
	var population = wielder.MYrena_rect.get_child_count()
	var OPrena = wielder.MYrena_rect.OPrena_rect
	var target
	for i in range(population-1,-1,-1):
		target = OPrena.get_child(i)
		if target.TYPE == 0:
			if target.position_auras.has_node(aura_name+str(aura_unique_id)):
				target.position_auras.get_node(aura_name+str(aura_unique_id)).get_removed()
