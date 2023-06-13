extends CanvasLayer

#############
## CONSTANTS
#############

const TRANSITION_DURATION: float = 0.25

#############
## VARIABLES
#############

@onready var color_rect: ColorRect = $ColorRect

###########
## METHODS
###########

func fade_to_color(to_color: Color, duration: float = TRANSITION_DURATION) -> void:
	var tween := create_tween()
	var from_color := Color(to_color.r, to_color.g, to_color.b, 0)
	tween.tween_property(color_rect, "color", to_color, duration).from(from_color)
	await tween.finished


func fade_from_color(from_color: Color, duration: float = TRANSITION_DURATION) -> void:
	var tween := create_tween()
	var to_color := Color(from_color.r, from_color.g, from_color.b, 0.0)
	tween.tween_property(color_rect, "color", to_color, duration).from(from_color)
	await tween.finished


func set_color(color: Color) -> void:
	color_rect.color = color
