##########################
## `BattleUnit`:
##     - BattleAnimations
##########################

extends Node2D
class_name BattleUnit

#############
## CONSTANTS
#############

const APPROACH_OFFSET: int = 48          # Offset to not cover the attackee
const APPROACHER_Z_INDEX: int = 10       # Ensure the approacher appears on top
const KNOCKBACK_OFFSET: int = 24         # Offset for knockback by the attacker
const ROOT_Z_INDEX: int = 0              # Default Z index for after attack

###########
## EXPORTS
###########

@export var stats: ClassStats: set = set_stats

#############
## VARIABLES
#############

@onready var root_position: Vector2 = global_position # Position before attack
@onready var battle_shield: Node2D = $BattleShield

@onready var defend_sound: AudioStreamPlayer = $DefendSound
@onready var impact_sound: AudioStreamPlayer = $ImpactSound
@onready var impact_defend_sound: AudioStreamPlayer = $ImpactDefendSound
@onready var heal_sound: AudioStreamPlayer = $HealSound

var battle_animations: BattleAnimations
var defend: bool = false : set = set_defend
var async_turn_pool: AsyncTurnPool = ReferenceStash.async_turn_pool

#############
## OVERRIDES
#############

func _ready() -> void:
	if stats is ClassStats:
		battle_animations = stats.battle_animations.instantiate()
		add_child(battle_animations)

#####################
## SETTERS & GETTERS
#####################

func set_stats(value: ClassStats) -> void:
	stats = value

	if stats == null:
		return

	if battle_animations != null:
		battle_animations.queue_free()
		battle_animations = stats.battle_animations.instantiate()
		add_child(battle_animations)


func set_defend(value: bool) -> void:
	defend = value
	battle_shield.visible = defend

	if defend:
		defend_sound.play()


###########
## METHODS
###########

func melee_attack(target: BattleUnit, battle_action: MeleeBattleAction) -> void:
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

	# Deal damage to the target
	deal_damage(target, battle_action)

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


func ranged_attack(target: BattleUnit, battle_action: RangedBattleAction) -> void:
	async_turn_pool.add(self)
	battle_animations.play("ranged_anticipation")
	await battle_animations.animation_finished

	var projectile: Projectile = battle_action.projectile.instantiate()
	# Add to the `BattleUnit` scene instead of current scene so we can await signal properly
	add_child(projectile)
	projectile.global_position = battle_animations.get_emission_position()
	projectile.move_to(target)
	projectile.contact.connect(ranged_attack_hit.bind(target, battle_action), CONNECT_ONE_SHOT)

	battle_animations.play("ranged_release")
	await battle_animations.animation_finished

	battle_animations.play("idle")
	async_turn_pool.remove(self)


func use_item(_target: BattleUnit, item: Item) -> void:
	async_turn_pool.add(self)
	battle_animations.play("item_anticipation")
	await battle_animations.animation_finished

	stats.health += item.heal_amount

	heal_sound.play()

	battle_animations.play("item_release")
	await battle_animations.animation_finished

	battle_animations.play("idle")
	async_turn_pool.remove(self)


func ranged_attack_hit(target: BattleUnit, battle_action: BattleAction) -> void:
	deal_damage(target, battle_action)
	target.take_hit(self)


func deal_damage(target: BattleUnit, battle_action: DamageBattleAction) -> void:
	var damage = (
		(
			(stats.level * 3 + (1 - target.stats.defense * 0.05)) / 2
		) * (
			stats.attack + battle_action.damage / 5
		) / 10
	)

	if target.defend:
		impact_defend_sound.play()
		target.defend = false # Turn off defend
		damage = round(damage / 2)
	else:
		impact_sound.play()

	target.stats.set_health(target.stats.health - damage)


func take_hit(attacker: BattleUnit) -> void:
	async_turn_pool.add(self)

	var knockback_position := global_position.move_toward(attacker.global_position, -KNOCKBACK_OFFSET)
	interpolate_position(knockback_position, 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)

	if stats.health == 0:
		battle_animations.play("death")
		await battle_animations.animation_finished

		async_turn_pool.remove(self)
		queue_free()
		return
	else:
		battle_animations.play("hit")
		await battle_animations.animation_finished
		battle_animations.play("idle")

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
