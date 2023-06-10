extends Projectile

#############
## VARIABLES
#############

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var flame: CPUParticles2D = $Flame
@onready var explosion: CPUParticles2D = $Explosion

###########
## METHODS
###########

func _animate_collision() -> void:
	animated_sprite.hide()
	flame.hide()

	explosion.emitting = true

	while explosion.emitting:
		await get_tree().process_frame

	collision_animation_finished.emit()
