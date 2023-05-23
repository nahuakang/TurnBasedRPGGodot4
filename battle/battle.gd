extends Node2D

@onready var player_battle_unit: BattleUnit = $PlayerBattleUnit/PlayerBattleUnit
@onready var enemy_battle_unit: BattleUnit = $EnemyBattleUnit/EnemyBattleUnit
@onready var pan_in_animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	await pan_in_animation_player.animation_finished

	player_battle_unit.melee_attack()
	enemy_battle_unit.melee_attack()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		SceneStack.pop()
