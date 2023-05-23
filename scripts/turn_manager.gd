extends Resource
class_name TurnManager

signal ally_turn_started()
signal ally_turn_ended()
signal enemy_turn_started()

enum {
	ALLY_TURN,  # 0
	ENEMY_TURN, # 1
}

var turn := ALLY_TURN : set = set_turn


func set_turn(turn_value: int) -> void:
	turn = turn_value

	match turn:
		ALLY_TURN: emit_signal("ally_turn_started")
		ENEMY_TURN:
			emit_signal("ally_turn_ended")
			emit_signal("enemy_turn_started")


func start() -> void:
	turn = ALLY_TURN


func advance_turn() -> void:
	# Using bitwise operator &
	# if turn == 0 (ALLY_TURN):
	# (0 + 1) & 1 -> 1 & 1 -> 1
	#   00000001 --- 1
	# & 00000001 --- 1
	# = 00000001 --- 1
	# if turn == 1 (ENEMY_TURN):
	# (1 + 1) & 1 -> 2 & 1 -> 0
	#   00000010 --- 2
	# & 00000001 --- 1
	# = 00000000 --- 0
	turn = int(turn + 1) & 1
