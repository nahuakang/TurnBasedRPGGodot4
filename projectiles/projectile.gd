extends Node2D
class_name Projectile

#############
## CONSTANTS
#############

const PROJECTILE_DURATION: float = 0.6

#############
## VARIABLES
#############

var async_turn_pool: AsyncTurnPool = ReferenceStash.async_turn_pool

###########
## SIGNALS
###########

signal contact
signal collision_animation_finished

#############
## OVERRIDES
#############

# To be overriden by inherited scenes
func _animate_collision() -> void:
	await get_tree().process_frame


###########
## METHODS
###########

func move_to(target: BattleUnit, trans: int = Tween.TRANS_LINEAR, easing: int = Tween.EASE_IN) -> void:
	z_index = 25

	async_turn_pool.add(self)

	var tween := create_tween().set_trans(trans).set_ease(easing)
	# Keep the player's y-position
	var target_position := Vector2(target.global_position.x, global_position.y)
	tween.tween_property(self, "global_position", target_position, PROJECTILE_DURATION).from_current()
	await tween.finished

	contact.emit()

	_animate_collision()
	await collision_animation_finished

	async_turn_pool.remove(self)
	queue_free()
