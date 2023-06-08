extends FocusMenu
class_name ContextMenu

#########
## ENUMS
#########

enum CONTEXT_OPTION {
	USE,
	INFO,
}

###########
## SIGNALS
###########

signal option_selected(option: CONTEXT_OPTION)

#############
## OVERRIDES
#############

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


#####################
## SIGNALS CALLBACKS
#####################

func _on_use_button_button_down() -> void:
	option_selected.emit(CONTEXT_OPTION.USE)


func _on_info_button_button_down() -> void:
	option_selected.emit(CONTEXT_OPTION.INFO)
