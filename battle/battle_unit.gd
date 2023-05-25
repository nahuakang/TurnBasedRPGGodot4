##########################
## `BattleUnit`:
##     - BattleAnimations
##########################

extends Node2D
class_name BattleUnit

@export var battle_animations_scene: PackedScene

@onready var root_position: Vector2 = global_position # Position before attack

const APPROACH_OFFSET: int = 48          # Offset to not cover the attackee
const KNOCKBACK_OFFSET: int = 24         # Offset for knockback by the attacker
const APPROACHER_Z_INDEX: int = 10       # Ensure the approacher appears on top
const ROOT_Z_INDEX: int = 0              # Default Z index for after attack
var battle_animations: BattleAnimations
var async_turn_pool: AsyncTurnPool = ReferenceStash.async_turn_pool

#############
## OVERRIDES
#############

func _ready() -> void:
	# `PackedScene.instantiate` returns a `Node`, which `BattleAnimations` inherits
	# Instantiate and add the specified `BattleAnimations` as a child
	battle_animations = battle_animations_scene.instantiate()
	add_child(battle_animations)


###########
## METHODS
###########

func melee_attack(target: BattleUnit) -> void:
	async_turn_pool.add(self)

	# Set Z index to make attacker render on top
	z_index = APPROACHER_Z_INDEX

	# Attacker approaches
	battle_animations.play("approach")
	# global_position ===> target_position <=== - APPROACH_OFFSET <=== target.global_position
	var target_position := target.global_position.move_toward(global_position, APPROACH_OFFSET)
	var animation_duration := battle_animations.get_current_animation_length()
	interpolate_position(target_position, animation_duration)
	await battle_animations.animation_finished

	# Target takes hit; `BattleUnit.take_hit` is a coroutine that runs separately from `melee`
	target.take_hit(self)

	# Animate melee action
	battle_animations.play("melee")
	await battle_animations.animation_finished

	# Attacker returns to root position
	battle_animations.play("return")
	animation_duration = battle_animations.get_current_animation_length()
	interpolate_position(root_position, animation_duration)
	await battle_animations.animation_finished

	# Reset Z index
	z_index = ROOT_Z_INDEX
	# Don't `await` after "idle" since "idle" is the default state
	battle_animations.play("idle")

	async_turn_pool.remove(self)


func take_hit(attacker: BattleUnit) -> void:
	async_turn_pool.add(self)

	var knockback_position := global_position.move_toward(attacker.global_position, -KNOCKBACK_OFFSET)
	interpolate_position(knockback_position, 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)

	battle_animations.play("hit")
	await battle_animations.animation_finished

	interpolate_position(root_position, 0.2, Tween.TRANS_CIRC)

	async_turn_pool.remove(self)


func interpolate_position(
	to: Vector2,
	duration: float,
	trans: int = Tween.TRANS_LINEAR,
	easing: int = Tween.EASE_IN_OUT
) -> void:
	var tween := create_tween().set_trans(trans).set_ease(easing)
	tween.tween_property(self, "global_position", to, duration)
	await tween.finished
