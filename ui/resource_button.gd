extends ParentButton
class_name ResourceButton

#############
## VARIABLES
#############

var resource: Resource

###########
## SIGNALS
###########

signal resource_selected(resource: Resource)

#####################
## SIGNALS CALLBACKS
#####################

func _on_button_down():
	resource_selected.emit(resource)
