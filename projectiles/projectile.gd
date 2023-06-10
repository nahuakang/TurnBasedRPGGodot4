extends Node2D
class_name Projectile

#############
## CONSTANTS
#############

const PROJECTILE_DURATION: float = 0.4

#############
## VARIABLES
#############

var async_turn_pool: AsyncTurnPool = ReferenceStash.async_turn_pool

###########
## METHODS
###########

func move_to(target: BattleUnit) -> void:
	async_turn_pool.add(self)

	var tween := create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	# Keep the player's y-position
	var target_position := Vector2(target.global_position.x, global_position.y)
	tween.tween_property(self, "global_position", target_position, PROJECTILE_DURATION).from_current()
	await tween.finished

	async_turn_pool.remove(self)
	queue_free()
