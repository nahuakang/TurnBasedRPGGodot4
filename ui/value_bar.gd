extends TextureRect
class_name ValueBar

#############
## VARIABLES
#############

@onready var decrease_bar := $DecreaseProgressBar
@onready var increase_bar := $IncreaseProgressBar
@onready var actual_bar := $ActualProgressBar

var bar_value: float = 0.0

###########
## SIGNALS
###########

signal animation_finished

#############
## OVERRIDES
#############

#func _ready() -> void:
#	await animate_bar(40, 60)
#	await animate_bar(30, 60)
#	await animate_bar(50, 60)
#	await animate_bar(45, 60)

###########
## METHODS
###########

func set_bar(value: float, max_value: float) -> void:
	bar_value = calculate_bar_value(value, max_value)
	decrease_bar.value = bar_value
	increase_bar.value = bar_value
	actual_bar.value = bar_value


## Animate the progress bar. `value` is the value to animate to.
## `max_value` is the maximum value that should not be exceeded.
## `duration` is the animation duration in seconds, default to 1.0.
func animate_bar(value: float, max_value: float, duration: float = 1.0) -> void:
	# A signal might be sent to trigger `animate_bar` when the ValueBar is not in
	# the current scene tree. If so, return immediately to avoid crashing
	if not is_inside_tree():
		return

	var previous_bar_value := bar_value
	bar_value = calculate_bar_value(value, max_value)

	var tween := create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

	# Healing
	if bar_value > previous_bar_value:
		decrease_bar.value = bar_value
		increase_bar.value = bar_value

		tween.tween_property(actual_bar, "value", bar_value, duration).from_current()
		await tween.finished

	elif bar_value < previous_bar_value:
		increase_bar.value = bar_value
		actual_bar.value = bar_value

		tween.tween_property(decrease_bar, "value", bar_value, duration).from_current()
		await tween.finished

	else:
		tween.kill()

	animation_finished.emit()


func calculate_bar_value(value: float, max_value: float) -> float:
	return (value / max_value) * 100.0
