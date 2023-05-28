extends Node2D

#############
## CONSTANTS
#############

const EXIT_TIMER_TIMOUT: float = 1.0
const BATTLE_WON_TIMEOUT: float = 0.5

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
@onready var battle_menu: BattleMenu = %BattleMenu

##############
## REFERENCES
##############

var turn_manager: TurnManager = ReferenceStash.turn_manager
var async_turn_pool: AsyncTurnPool = ReferenceStash.async_turn_pool

#############
## OVERRIDES
#############

func _ready() -> void:
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
	var player_stats: PlayerClassStats = player_battle_unit.stats

	var previous_level := player_battle_unit.stats.level
	# TODO: This is hardcoded experience
	player_battle_unit.stats.experience += 105

	if player_battle_unit.stats.level > previous_level:
		await level_up_ui.level_up()

	timer.start(BATTLE_WON_TIMEOUT)
	await timer.timeout


func exit_battle() -> void:
	timer.start(EXIT_TIMER_TIMOUT)
	await timer.timeout
	SceneStack.pop()


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
	battle_menu.show()

	battle_menu.grab_action_focus()
	var menu_option: BattleMenu.MENU_OPTION = await battle_menu.menu_option_selected
	match menu_option:
		BattleMenu.MENU_OPTION.ACTION:
			player_battle_unit.melee_attack(enemy_battle_unit)
		BattleMenu.MENU_OPTION.ITEM:
			print("TODO: Item")
			turn_manager.advance_turn()
		BattleMenu.MENU_OPTION.RUN:
			print("TODO: Run")
			SceneStack.pop() # Note this doesn't work playing the `battle.tscn` itself

	battle_menu.hide()




func _on_enemy_turn_started() -> void:
	# No enemy unit exists in the scene, player won
	if not is_instance_valid(enemy_battle_unit) or enemy_battle_unit.is_queued_for_deletion():
		await battle_won()

		exit_battle()
		return

	enemy_battle_unit.melee_attack(player_battle_unit)


func _on_async_turn_pool_turn_over() -> void:
	turn_manager.advance_turn()
