extends Node
enum Targeting {
	none,
	myself,
	one_unit,
	one_ally,
	one_enemy,
	lane
}

enum PassiveTriggers {
	none,
	cleanup_phase,
	prep_phase,
	being_targeted
}
