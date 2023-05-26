extends Node2D

#############
## VARIABLES
#############

@onready var player_battle_unit: BattleUnit = $PlayerBattleUnit/PlayerBattleUnit
@onready var enemy_battle_unit: BattleUnit = $EnemyBattleUnit/EnemyBattleUnit
@onready var pan_in_animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

const EXIT_TIMER_TIMOUT: float = 1.0

var turn_manager: TurnManager = ReferenceStash.turn_manager
var async_turn_pool: AsyncTurnPool = ReferenceStash.async_turn_pool

#############
## OVERRIDES
#############

func _ready() -> void:
	await pan_in_animation_player.animation_finished

	turn_manager.ally_turn_started.connect(_on_ally_turn_started)
	turn_manager.enemy_turn_started.connect(_on_enemy_turn_started)
	turn_manager.start()

	async_turn_pool.turn_over.connect(_on_async_turn_pool_turn_over)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		SceneStack.pop()

###########
## METHODS
###########

func exit_battle() -> void:
	timer.start(EXIT_TIMER_TIMOUT)
	await timer.timeout
	SceneStack.pop()


###################
## SIGNALS METHODS
###################

func _on_ally_turn_started() -> void:
	if not is_instance_valid(player_battle_unit):
		get_tree().quit()
		return

	player_battle_unit.melee_attack(enemy_battle_unit)


func _on_enemy_turn_started() -> void:
	if not is_instance_valid(enemy_battle_unit) or enemy_battle_unit.is_queued_for_deletion():
		exit_battle()
		return

	enemy_battle_unit.melee_attack(player_battle_unit)


func _on_async_turn_pool_turn_over() -> void:
	turn_manager.advance_turn()
