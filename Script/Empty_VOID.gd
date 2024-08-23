extends Control


var TYPE = 7
var VOIDING = 0

#card placement empty slots
var SETT = 0
var SITT = 0
var Replaced_a_void = 0

var opposable = 1
#whether I can be considered an opposer (I'm empty opposer)
#used for two units dying across each other, so that unit doesnt target a dying unit

var besieging_damage = 0
#so that I don't need to check for TYPE == 0 every siege damage check
