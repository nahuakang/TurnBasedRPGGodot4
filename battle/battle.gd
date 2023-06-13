extends Node2D

#############
## CONSTANTS
#############

const EXIT_TIMER_TIMOUT: float = 1.0
const BATTLE_WON_TIMEOUT: float = 0.5
const CAMERA_TWEEN_OFFSET: int = 32
const CAMERA_TWEEN_ZOOMIN_SCALE: float = 1.25
const CAMERA_TWEEN_FOCUS_ZOOM_IN := Vector2(CAMERA_TWEEN_ZOOMIN_SCALE, CAMERA_TWEEN_ZOOMIN_SCALE)
const CAMERA_TWEEN_FOCUS_ZOOM_DEFAULT := Vector2.ONE
const DEFEND_TIMEOUT: float = 1.0

#############
## VARIABLES
#############

@onready var player_battle_unit: BattleUnit = $PlayerBattleUnit/PlayerBattleUnit
@onready var enemy_battle_unit: BattleUnit = $EnemyBattleUnit/EnemyBattleUnit
@onready var pan_in_animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var player_battle_unit_info: BattleUnitInfo = $BattleUI/PlayerBattleUnitInfo
@onready var enemy_battle_unit_info: BattleUnitInfo = $BattleUI/EnemyBattleUnitInfo
@onready var level_up_ui: LevelUpUI = %LevelUpUI
@onready var battle_menu_manager: BattleMenuManager = %BattleMenuManager
@onready var battle_camera: BattleCamera = $BattleCamera
# The camera position to return to after tweening camera movement for attack
@onready var center_position: Vector2 = $CenterRoot/CenterPoint.global_position
# The camera position to tween to when the player attacks the enemy
@onready var enemy_camera_position: Vector2 = get_battle_unit_camera_position(enemy_battle_unit)
# The camera position to tween to when the enemy attacks the player
@onready var player_camera_position: Vector2 = get_battle_unit_camera_position(player_battle_unit)

##############
## REFERENCES
##############

var turn_manager: TurnManager = ReferenceStash.turn_manager
var async_turn_pool: AsyncTurnPool = ReferenceStash.async_turn_pool

#############
## OVERRIDES
#############

func _ready() -> void:
	var encounter_class: ClassStats = ReferenceStash.encounter_class

	if encounter_class is ClassStats:
		enemy_battle_unit.stats = encounter_class.duplicate()

	player_battle_unit_info.stats = player_battle_unit.stats
	enemy_battle_unit_info.stats = enemy_battle_unit.stats

	await pan_in_animation_player.animation_finished

	turn_manager.ally_turn_started.connect(_on_ally_turn_started)
	turn_manager.enemy_turn_started.connect(_on_enemy_turn_started)
	turn_manager.start()

	async_turn_pool.turn_over.connect(_on_async_turn_pool_turn_over)

## DEBUGGING METHOD
#func _unhandled_input(event: InputEvent):
#	if event.is_action_pressed("ui_accept"):
#		SceneStack.pop()

###########
## METHODS
###########

func battle_won() -> void:
	timer.start(BATTLE_WON_TIMEOUT)
	await timer.timeout

	# Coercing into PlayerClassStats from ClassStats
#	var player_stats: PlayerClassStats = player_battle_unit.stats

	var previous_level := player_battle_unit.stats.level
	# TODO: This is hardcoded experience
	player_battle_unit.stats.experience += 105

	if player_battle_unit.stats.level > previous_level:
		await level_up_ui.level_up()

	timer.start(BATTLE_WON_TIMEOUT)
	await timer.timeout


func exit_battle() -> void:
#	timer.start(EXIT_TIMER_TIMOUT)
#	await timer.timeout

	await Transition.fade_to_color(Color.BLACK)
	Transition.fade_from_color(Color.BLACK)

	SceneStack.pop()


func get_battle_unit_camera_position(battle_unit: BattleUnit) -> Vector2:
	var start_position := Vector2(battle_unit.global_position.x, center_position.y)
	var final_position := start_position.move_toward(center_position, CAMERA_TWEEN_OFFSET)
	return final_position

###################
## SIGNALS METHODS
###################

func _on_ally_turn_started() -> void:
	if not is_instance_valid(player_battle_unit):
		timer.start(EXIT_TIMER_TIMOUT)
		await timer.timeout
		get_tree().quit()
		return

	# Using `BattleMenu` to handle player input in the turn
	await battle_menu_manager.show_battle_menu()

	var selected_resource: Resource = await battle_menu_manager.battle_menu_resource_selected

	if selected_resource is MeleeBattleAction:
		battle_camera.focus_target(enemy_camera_position, CAMERA_TWEEN_FOCUS_ZOOM_IN)
		player_battle_unit.melee_attack(enemy_battle_unit, selected_resource)

	elif selected_resource is RangedBattleAction:
		player_battle_unit.ranged_attack(enemy_battle_unit, selected_resource)

	elif selected_resource.name == "Defend":
		async_turn_pool.add(self)
		player_battle_unit.defend = true
		timer.start(DEFEND_TIMEOUT)
		await timer.timeout
		async_turn_pool.remove(self)

	elif selected_resource is Item:
		player_battle_unit.use_item(player_battle_unit, selected_resource)

	elif selected_resource.name == "Run":
		exit_battle()


func _on_enemy_turn_started() -> void:
	# No enemy unit exists in the scene, player won
	if not is_instance_valid(enemy_battle_unit) or enemy_battle_unit.is_queued_for_deletion():
		await battle_won()

		exit_battle()
		return

	var battle_action = enemy_battle_unit.stats.battle_actions.front()

	if battle_action is MeleeBattleAction:
		battle_camera.focus_target(player_camera_position, CAMERA_TWEEN_FOCUS_ZOOM_IN)
		enemy_battle_unit.melee_attack(player_battle_unit, battle_action)

	elif battle_action is RangedBattleAction:
		enemy_battle_unit.ranged_attack(player_battle_unit, battle_action)


func _on_async_turn_pool_turn_over() -> void:
	await battle_camera.focus_target(center_position, CAMERA_TWEEN_FOCUS_ZOOM_DEFAULT)
	turn_manager.advance_turn()
