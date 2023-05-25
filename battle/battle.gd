extends Node2D

#############
## VARIABLES
#############

@onready var player_battle_unit: BattleUnit = $PlayerBattleUnit/PlayerBattleUnit
@onready var enemy_battle_unit: BattleUnit = $EnemyBattleUnit/EnemyBattleUnit
@onready var pan_in_animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

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


func _on_ally_turn_started() -> void:
	player_battle_unit.melee_attack(enemy_battle_unit)


func _on_enemy_turn_started() -> void:
	enemy_battle_unit.melee_attack(player_battle_unit)


func _on_async_turn_pool_turn_over() -> void:
	turn_manager.advance_turn()
