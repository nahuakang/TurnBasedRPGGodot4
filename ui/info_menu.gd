extends FocusMenu
class_name InfoMenu

#############
## VARIABLES
#############

@onready var rich_text_label: RichTextLabel = %RichTextLabel

var text: String = "" : set = set_text

#####################
## SETTERS & GETTERS
#####################

func set_text(value: String) -> void:
	text = value
	rich_text_label.text = text
