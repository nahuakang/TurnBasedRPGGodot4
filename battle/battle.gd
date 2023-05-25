extends Node2D

#############
## VARIABLES
#############

@onready var player_battle_unit: BattleUnit = $PlayerBattleUnit/PlayerBattleUnit
@onready var enemy_battle_unit: BattleUnit = $EnemyBattleUnit/EnemyBattleUnit
@onready var pan_in_animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var turn_manager: TurnManager = ReferenceStash.turn_manager

#############
## OVERRIDES
#############

func _ready() -> void:
	await pan_in_animation_player.animation_finished

	turn_manager.ally_turn_started.connect(_on_ally_turn_started)
	turn_manager.enemy_turn_started.connect(_on_enemy_turn_started)
	turn_manager.start()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		SceneStack.pop()


func _on_ally_turn_started() -> void:
	await player_battle_unit.melee_attack(enemy_battle_unit)

	turn_manager.advance_turn()


func _on_enemy_turn_started() -> void:
	await enemy_battle_unit.melee_attack(player_battle_unit)

	turn_manager.advance_turn()
