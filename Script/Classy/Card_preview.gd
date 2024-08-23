extends Control


class_name Card_preview

#Ok and now it spawn under Oblysk
#Well and I just moved it under UI_layer
#Under oblysk again
#Now under SCROLLH

@onready var the_button = $"../../THE_BUTTON"

@onready var arena_rect1 = $"../../../First_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect1 = $"../../../First_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var arena1 = $"../../../First_lane/Card_layer/SCROLLA/Arena"
@onready var abarena1 = $"../../../First_lane/Card_layer/SCROLLB/Abarena"
@onready var card_layer1 = $"../../../First_lane/Card_layer"

@onready var arena_rect2 = $"../../../Mid_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect2 = $"../../../Mid_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var arena2 = $"../../../Mid_lane/Card_layer/SCROLLA/Arena"
@onready var abarena2 = $"../../../Mid_lane/Card_layer/SCROLLB/Abarena"
@onready var card_layer2 = $"../../../Mid_lane/Card_layer"

@onready var arena_rect3 = $"../../../Last_lane/Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"
@onready var abarena_rect3 = $"../../../Last_lane/Card_layer/SCROLLB/Abarena/SIZECHECK/ArenaRect"
@onready var arena3 = $"../../../Last_lane/Card_layer/SCROLLA/Arena"
@onready var abarena3 = $"../../../Last_lane/Card_layer/SCROLLB/Abarena"
@onready var card_layer3 = $"../../../Last_lane/Card_layer"

##appears as a child of this scene's root node i guess
##it does when all it has above it is control nodes i believe, c-layers somehow stop it
var arena_rect 
var abarena_rect 
var arena 
var abarena 
var card_layer



