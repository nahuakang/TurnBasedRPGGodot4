extends Camera2D
class_name BattleCamera

#############
## CONSTANTS
#############

const CAMERA_FOCUS_TWEEN_DURATION: float = 0.4

###########
## METHODS
###########

func focus_target(
	target_position: Vector2,
	target_zoom: Vector2,
	duration: float = CAMERA_FOCUS_TWEEN_DURATION
) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target_position, duration).from_current()
	tween.parallel().tween_property(
		self,
		"zoom",
		target_zoom,
		CAMERA_FOCUS_TWEEN_DURATION
	).from_current()
	await tween.finished
