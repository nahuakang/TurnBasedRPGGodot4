extends HBoxContainer
class_name BattleMenu

#############
## CONSTANTS
#############

const MENU_ANIMATION_DISTANCE := Vector2(0, 36)
const MENU_ANIMATION_DURATION: float = 0.4

#############
## VARIABLES
#############

@onready var action_button: TextureButton = %ActionButton
@onready var item_button: TextureButton = %ItemButton
@onready var run_button: TextureButton = %RunButton

#########
## ENUMS
#########

enum MENU_OPTION {
	ACTION,
	ITEM,
	RUN
}

###########
## SIGNALS
###########

signal menu_option_selected(option: MENU_OPTION)

#############
## METHODS
#############

func grab_action_focus() -> void:
	action_button.grab_focus()


func show_menu() -> void:
	show()

	# Going up MENU_ANIMATION_DISTANCE
	var tween := create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		self,
		"global_position",
		-MENU_ANIMATION_DISTANCE,
		MENU_ANIMATION_DURATION
	).as_relative().from_current()
	await tween.finished


func hide_menu() -> void:
	# Going down MENU_ANIMATION_DISTANCE
	var tween := create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		self,
		"global_position",
		MENU_ANIMATION_DISTANCE,
		MENU_ANIMATION_DURATION
	).as_relative().from_current()
	await tween.finished

	hide()


##################
## SIGNAL METHODS
##################

func _on_action_button_button_down():
	menu_option_selected.emit(MENU_OPTION.ACTION)


func _on_item_button_button_down():
	menu_option_selected.emit(MENU_OPTION.ITEM)


func _on_run_button_button_down():
	menu_option_selected.emit(MENU_OPTION.RUN)
