extends HBoxContainer
class_name BattleMenu

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
## OVERRIDES
#############

func _ready() -> void:
	action_button.grab_focus()


##################
## SIGNAL METHODS
##################

func _on_action_button_button_down():
	menu_option_selected.emit(MENU_OPTION.ACTION)


func _on_item_button_button_down():
	menu_option_selected.emit(MENU_OPTION.ITEM)


func _on_run_button_button_down():
	menu_option_selected.emit(MENU_OPTION.RUN)
