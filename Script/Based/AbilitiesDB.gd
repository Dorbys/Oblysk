extends Node


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var NAMEPOSITION = 0
var COOLDOWNPOSITION = 1
var TARGPOSITION = 2
var PASSIVETRIGPOSITION = 3					


var HERO_ABILITIES_DB = [
["PASSIVE", 0, Enums.Targeting.myself, Enums.PassiveTriggers.being_targeted],
["PASSIVE", 0, Enums.Targeting.one_unit,Enums.PassiveTriggers.none],
["Advance", 4, Enums.Targeting.myself,Enums.PassiveTriggers.none],
["PASSIVE", 0, Enums.Targeting.one_unit,Enums.PassiveTriggers.none],
["PASSIVE", 0, Enums.Targeting.one_unit,Enums.PassiveTriggers.none]
]

#passive so it should autoallocate itself 

#var HERO_ABILITY_DESCRIPTIONS_DB = [
#["ACAMAR"],
#["DORBYS"],
#["KAJUS"],
#["KIMMEDI"],
#["PLOTT"]
#]

var Kajus_ability_description = "Cooldown(4): Summon a 6/2/8 Legionaire"

#GIVE EVERYONE BASIC ABILITY, THEN PROCEED


func PASSIVE(_Target):
	print("there was an attempt to trigger PASSIVE manually")
	
func Advance(Caster):
	await Caster.MYrena_rect.spawn_unit(2)



func Warmarch(Target):
	Target.increase_AttackM(-2, 1)	
	await Target.take_damage(2)



















#var NAMEPOSITION = 0
#var COOLDOWNPOSITION = 1
#var TARGPOSITION = 2
#var PASSIVETRIGPOSITION = 3		

#so that I don't have to scroll so far, obviously needs to be updated manua

var CREEP_ABILITIES_DB = [
["Golem_heart", 0, Enums.Targeting.one_ally, Enums.PassiveTriggers.being_targeted],
["Chill_up", 0, Enums.Targeting.myself, Enums.PassiveTriggers.being_targeted],
[null, "Legionaire"],
["PASSIVE", 0, Enums.Targeting.one_unit,Enums.PassiveTriggers.none],
["PASSIVE", 0, Enums.Targeting.one_unit,Enums.PassiveTriggers.none],
["Warmarch", 0, Enums.Targeting.myself, Enums.PassiveTriggers.being_targeted],
["PASSIVE", 0, Enums.Targeting.one_unit,Enums.PassiveTriggers.none]]



