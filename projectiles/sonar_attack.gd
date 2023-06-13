extends Projectile

#############
## VARIABLES
#############

@onready var animation_player: AnimationPlayer = $AnimationPlayer

###########
## METHODS
###########

func _animate_collision() -> void:
	animation_player.play("end")
	await animation_player.animation_finished
	collision_animation_finished.emit()


#####################
## SIGNALS CALLBACKS
#####################

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name != "start":
		return

	animation_player.play("repeat")
