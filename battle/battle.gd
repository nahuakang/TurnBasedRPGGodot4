extends Node2D

@onready var player_battle_unit: BattleUnit = $PlayerBattleUnit/PlayerBattleUnit
@onready var enemy_battle_unit: BattleUnit = $EnemyBattleUnit/EnemyBattleUnit


func _ready() -> void:
	player_battle_unit.melee_attack()
	enemy_battle_unit.melee_attack()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		SceneStack.pop()
