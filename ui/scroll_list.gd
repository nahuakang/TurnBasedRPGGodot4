extends PanelContainer

#############
## VARIABLES
#############

@onready var resource_button := $MarginContainer/ScrollContainer/MarginContainer/ButtonContainer/ResourceButton

#############
## OVERRIDES
#############

func _ready():
	resource_button.grab_focus()
