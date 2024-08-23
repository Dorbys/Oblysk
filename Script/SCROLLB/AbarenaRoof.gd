extends ColorRect


@onready var abarena_rect = $"../AbarenaRect"
@onready var abarena_mid = $"../AbarenaMid"
@onready var hand_rect = $"../../../../../UI_layer/SCROLLH/HANDA/SIZECHECK/HandRect"
@onready var arena_rect = $"../../../../../Card_layer/SCROLLA/Arena/SIZECHECK/ArenaRect"


func _can_drop_data(_at_position, DropData):
	if DropData[0] == 1:
		return true
	else :
		return true
		#bs here nowwwwwwwwwwwwww

	
func _drop_data(at_position, DropData):
	if DropData[0] == 0:
		abarena_rect.Carrying = 0
		abarena_rect.Adding_Units(at_position, DropData[1])
		hand_rect.get_child(DropData[2]).queue_free()
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		hand_rect.collide_cards()
	if DropData[0] == 1:
		abarena_rect.TargetingSpell = 0
		abarena_rect.ResolvingSingleTargetSpell(at_position, DropData[1])
		hand_rect.get_child(DropData[2]).queue_free()
		if abarena_mid.get_child_count()>0:
			abarena_mid.get_child(0).queue_free()
		await get_tree().create_timer(Base.FAKE_DELTA).timeout
		hand_rect.collide_cards()
		pass 
		
