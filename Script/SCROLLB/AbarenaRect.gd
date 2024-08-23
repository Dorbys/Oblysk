extends ColorRect
@onready var scrollb = $"../../.."
@onready var arena_rect = $"../../../../SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var arena_roof = $"../../../../SCROLLA/Arena/SIZECHECK/ArenaRoof"
@onready var card_layer = $"../../../../"
@onready var abarena_mid = $"../AbarenaMid"


# ::::::::::::::::::
@export var CARD: PackedScene
@export var SHADOW: PackedScene
@export var EFFECT: PackedScene
@export var VOID: PackedScene
@export var STARTSET = 60 + (Base.CARD_WIDTH/2)
@export var OFFSET = 16

#so that these are only calced once
var OWN_Y = self.position.y
var OWN_HEIGHT = self.size.y
var SHADOW_HEIGHT = OWN_Y + OWN_HEIGHT

#vars for placing units:
var Carrying = 0
var Measuring = 0
#vars for aiming spells:
var TargetingSpell = 0
var Aiming = 0
#vars for equipping items
var EquippingItem = 0
var Iteming = 0



var Slot_calc_top = -(STARTSET)
var	Slot_calc_bot =	Base.CARD_WIDTH + OFFSET
	
func Adding_Units(_at_position, ID):
	Carrying = 0
	var replacing_replacer = 0
	if self.get_child_count()-1 >= Shadow_index:
		if get_child(Shadow_index).Replaced_a_void == 1:
			replacing_replacer = 1
		get_child(Shadow_index).queue_free()
	else:
		print("NO SHADOW detected>>>>>>>>>>>>>>")
#	var opposite_slot = arena_rect.get_child(Shadow_index)
#	if opposite_slot.TYPE != 0:
#		opposite_slot.SETT = 1
#		opposite_slot.SITT = 1
	if replacing_replacer == 0:
		arena_rect.insert_void(Shadow_index, 1, 1)
	await get_tree().create_timer(Base.FAKE_DELTA).timeout
	var population = get_child_count()
	var another = CARD.instantiate()
#	another.Unit_Name = Base.UNITS_DB[ID][Base.NAMEPOSITION]
	another.Unit_Pfp = Base.UNIT_TEXTURES[ID]
	another.Unit_Small = Base.SMALL_TEXTURES[0] 		#TESTUS HEREEEEEEEEE
	another.Unit_Attack = Base.UNITS_DB[ID][Base.ATTACKPOSITION]
	another.Unit_Health = Base.UNITS_DB[ID][Base.HEALTHPOSITION]
	another.HERO = Base.UNITS_DB[ID][Base.HEROPOSITION]

	
	if Shadow_index > population:
		another.position.x= STARTSET + population * (Base.CARD_WIDTH + OFFSET)
		add_child(another)
	else:
		add_child(another)
		for i in (population-Shadow_index):
			move_child(get_child(population-(i+1)),population-i)
		collide_units()
	
func Cheating_Units(ID):

	var population = get_child_count()
	var another = CARD.instantiate()
	another.VOIDING = 0
#	another.Unit_Name = Base.UNITS_DB[ID][Base.NAMEPOSITION]
	another.Unit_Pfp = Base.UNIT_TEXTURES[ID]
	another.Unit_Attack = Base.UNITS_DB[ID][Base.ATTACKPOSITION]
	another.Unit_Health = Base.UNITS_DB[ID][Base.HEALTHPOSITION]
	another.position.x= STARTSET + population * (Base.CARD_WIDTH + OFFSET)
	add_child(another)

	
func Remove_Unit(which):
	
	if get_child_count() > which:
		get_child(which).queue_free()
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		collide_units()

func collide_units():
	var population = get_child_count()
	for i in population:
		get_child(i).position.x= STARTSET + (i * (Base.CARD_WIDTH + OFFSET))
		
func fake_collide_units(index):
	var population = get_child_count()
	for i in population:
		if i < index:
			get_child(i).position.x= STARTSET + (i * (Base.CARD_WIDTH + OFFSET))
		else:
			get_child(i).position.x= STARTSET + ((i+1) * (Base.CARD_WIDTH + OFFSET))
	
func ResolvingSingleTargetSpell(XY, ID):
	var population = get_child_count()
	var Mouse_X = XY.x
	var Scroll_value = scrollb.get_h_scroll_bar().get_value()
	var Effect_slot = round((Mouse_X+ Slot_calc_top + Scroll_value) / Slot_calc_bot )
	if Effect_slot < 0:
		Effect_slot = 0
	if Effect_slot > population-1:
		Effect_slot = population-1
	if Effect_slot >= 0:
		var ChildX =  self.get_child(Effect_slot).position.x
		if	(Mouse_X > ChildX - 0.5*Base.CARD_WIDTH
			and
			Mouse_X < ChildX + 0.5*Base.CARD_WIDTH):
			var Target =  self.get_child(Effect_slot)
			SpellsDB.call(str(SpellsDB.SPELLS_DB[ID][0]),Target)
	pass


func _on_abarena_roof_mouse_entered():
#	for i in (self.get_child_count()-1):
#		if self.get_child(i).SETT == 0:
#			self.get_child(i).queue_free()
##			await get_tree().create_timer(Base.FAKE_DELTA).timeout
#			print("this void was kinda late lol" + str(i))
	if Carrying == 1:
		Measuring = 1
		Shadow_preview()
	if TargetingSpell == 1:
		Aiming = 1
		SpellEffect_preview()
#	arena_roof.set_block_signals(true)
		
func _on_abarena_roof_mouse_exited():
	var replacing_replacer = 0
	Measuring = 0
	Aiming = 0
	
	for i in abarena_mid.get_child_count():
		abarena_mid.get_child(i).queue_free()
	if Carrying == 1:
		if self.get_child_count() >= New_Slot+1:
			if get_child(New_Slot).TYPE == 4:
				if get_child(New_Slot).Replaced_a_void == 1:
					replacing_replacer = 1
				Remove_Unit(New_Slot)
				arena_rect.collide_units()
				if replacing_replacer == 1:
					insert_void(New_Slot, 1,1)
			
			else:
				var population = get_child_count()
				for i in population:
					if get_child(i).TYPE == 4:
						Remove_Unit((get_child(i).get_index()))
						print("KICKED ASS")
		else: print("Almost crashed by UFM mexit lol")
#	arena_roof.set_block_signals(false)
	

func SpellEffect_preview():		
	var population = get_child_count()
	var Mouse_X = get_global_mouse_position().x
	var Scroll_value = scrollb.get_h_scroll_bar().get_value()
	var Effect_slot = round((Mouse_X+ Slot_calc_top + Scroll_value) / Slot_calc_bot )
	if Effect_slot > population-1:
		Effect_slot = population-1
	if Effect_slot >= 0:
		var ChildX =  self.get_child(Effect_slot).position.x
	# +0.5 bcs I'm aiming for the middle of card and looking around - easiest calc?
		while TargetingSpell == 1 and Aiming == 1:
			if Effect_slot> population:
				Effect_slot = population
			if	(Mouse_X > ChildX - 0.5*Base.CARD_WIDTH
				and
				Mouse_X < ChildX + 0.5*Base.CARD_WIDTH):
				if abarena_mid.get_child_count() == 0:
					var another = EFFECT.instantiate()
					another.position.x = ChildX
					abarena_mid.add_child(another)
				elif abarena_mid.get_child_count() == 1:
					var ETarget = abarena_mid.get_child(0)
					ETarget.position.x = ChildX
					ETarget.modulate.a = 1
				else:
					print("abarena_mid has too many children ====================")
			elif abarena_mid.get_child_count() == 1:
					var ETarget = abarena_mid.get_child(0)
					ETarget.modulate.a = 0
			Mouse_X = get_global_mouse_position().x
			Scroll_value = scrollb.get_h_scroll_bar().get_value()
			Effect_slot = round((Mouse_X+ Slot_calc_top + Scroll_value) / Slot_calc_bot ) 
			if Effect_slot > population-1:
				Effect_slot = population-1
			if Effect_slot >= 0:
				ChildX =  self.get_child(Effect_slot).position.x
#			print("ESlot: " + str(Effect_slot))	
			await get_tree().create_timer(Base.FAKE_GAMMA).timeout


func round_to_closest_empty(num, allowed_numbers):
	var closest = allowed_numbers[0]
	var smallest_diff = abs(closest - num)
	
	for i in range(1, allowed_numbers.size()):
		var diff = abs(allowed_numbers[i] - (num))
		if diff < smallest_diff:
			smallest_diff = diff
			closest = allowed_numbers[i]
	
	return closest

var Shadow_index = 0
var empty_slots = []
var New_Slot = 0
func Shadow_preview():
	var population = get_child_count()
	empty_slots = []
	for i in self.get_child_count():
		if self.get_child(i).SITT == 1:
			empty_slots.append(i)
	var another = SHADOW.instantiate()
	var Scroll_value = scrollb.get_h_scroll_bar().get_value()
	var Mouse_X = get_global_mouse_position().x
	
	New_Slot = round((Mouse_X+ Slot_calc_top + Scroll_value) / Slot_calc_bot )
	if len(empty_slots) != 0:
		New_Slot = round_to_closest_empty(New_Slot, empty_slots)
	if New_Slot >= population:
		
		another.position.x= STARTSET + population * (Base.CARD_WIDTH + OFFSET)
		add_child(another)
		Shadow_index = another.get_index()

	else:
		var Rtarget = self.get_child(New_Slot)
		if Rtarget.TYPE == 7:
			if Rtarget.SETT == 1:
				another.Replaced_a_void = 1
			Rtarget.queue_free()

		add_child(another)
		if New_Slot < 0:
			New_Slot = 0

		for i in (population-New_Slot):
			move_child(get_child(population-(i+1)),population-i)
		await get_tree().create_timer(Base.FAKE_DELTA).timeout

		if another.Replaced_a_void == 0:
			arena_rect.fake_collide_units(New_Slot)
		collide_units()
		Shadow_index = another.get_index()
	Shadow_follow()
	
func Shadow_follow():

	while Carrying == 1 and Measuring == 1:
		var population = get_child_count()
#		if population < 0:
#			population = 0
		var Scroll_value = scrollb.get_h_scroll_bar().get_value()
		var Mouse_X = get_global_mouse_position().x
		New_Slot = ((Mouse_X+ Slot_calc_top + Scroll_value) / Slot_calc_bot )
#		print(New_Slot)
		empty_slots = []
		for i in self.get_child_count():
			if self.get_child(i).SITT == 1:
				if self.get_child(i).TYPE == 7 or self.get_child(i).Replaced_a_void == 1:
					empty_slots.append(i)
		if len(empty_slots) != 0:
			New_Slot = round_to_closest_empty(New_Slot, empty_slots)
		else:
			New_Slot = round(New_Slot)
		
		var NSvsSI = abs(New_Slot-Shadow_index)
		if New_Slot > population -1:
#			print("NS above population")
			New_Slot = population-1
			if NSvsSI > 0.05:
				if Carrying != 1 or Measuring != 1:
					break
				if Shadow_index <= population-1 and New_Slot <= population-1:
					#necessary if statement because of frame 1 shenenigans
					move_child(get_child(Shadow_index), New_Slot)
#				if Shadow_index < abarena_rect.get_child_count():
#					if abarena_rect.get_child(Shadow_index).TYPE == 7:
#						abarena_rect.move_child(abarena_rect.get_child(Shadow_index), New_Slot)
				
				collide_units()
				arena_rect.collide_units()
				
				Shadow_index = New_Slot
		elif NSvsSI > 0.05:
			if New_Slot < 0:
				New_Slot = 0
#			print("SI: " +str(Shadow_index))
#			print("NS: " +str(New_Slot))
#			move_child(get_child(Shadow_index), New_Slot)
			if self.get_child(New_Slot).TYPE == 7:
				swap_children(self,Shadow_index, New_Slot)	
			else: move_child(get_child(Shadow_index), New_Slot)	

			
#			if abarena_rect.get_child(Shadow_index).TYPE == 7:
#				abarena_rect.move_child(abarena_rect.get_child(Shadow_index), New_Slot)
			#This moves the void opposite of the shadow
			collide_units()
			if self.get_child(New_Slot).Replaced_a_void == 0:
				arena_rect.fake_collide_units(New_Slot)
#			await get_tree().create_timer(Base.FAKE_GAMMA).timeout
			Shadow_index = New_Slot		#pass
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
#		await get_tree().create_timer(1).timeout
	





	
func insert_void(index, sett_status, sitt_status):
	var another = VOID.instantiate()
	if sett_status == 1:
		another.SETT = 1
	if sitt_status == 1:
		another.SITT = 1
	add_child(another)
	move_child(another, index)
	collide_units()
	
	
func swap_children(node, index1, index2):
	var child1 = node.get_child(index1)
	var child2 = node.get_child(index2)

	node.move_child(child1, index2)
	node.move_child(child2, index1)
