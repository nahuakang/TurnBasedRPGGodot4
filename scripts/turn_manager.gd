extends Resource
class_name TurnManager

###########
## Signals
###########

signal ally_turn_started()
signal ally_turn_ended()
signal enemy_turn_started()

#########
## ENUMS
#########

enum TURN {
	ALLY_TURN,  # 0
	ENEMY_TURN, # 1
}

#############
## VARIABLES
#############

var turn := TURN.ALLY_TURN : set = set_turn

###########
## METHODS
###########

func set_turn(turn_value: TURN) -> void:
	turn = turn_value

	match turn:
		TURN.ALLY_TURN: emit_signal("ally_turn_started")
		TURN.ENEMY_TURN:
			emit_signal("ally_turn_ended")
			emit_signal("enemy_turn_started")


func start() -> void:
	set_turn(TURN.ALLY_TURN)


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
	var turn_value := int(turn + 1) & 1
	set_turn(turn_value)
