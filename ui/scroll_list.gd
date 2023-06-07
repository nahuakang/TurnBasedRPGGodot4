extends PanelContainer
class_name ScrollList

#############
## VARIABLES
#############

@onready var resource_button: ResourceButton = $MarginContainer/ScrollContainer/MarginContainer/ButtonContainer/ResourceButton
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var button_container: VBoxContainer = %ButtonContainer

#############
## OVERRIDES
#############

func _ready():
	resource_button.grab_focus()
	connect_scroll_children()


###########
## METHODS
###########

func connect_scroll_children() -> void:
	for button in button_container.get_children():
		if button.is_connected("focus_entered", _on_button_focused):
			continue
		button.connect("focus_entered", _on_button_focused)


func get_focused_scroll_amount() -> int:
	var focused_button := get_viewport().gui_get_focus_owner()
	var previous_scroll_amount: int = scroll_container.scroll_vertical
	scroll_container.ensure_control_visible(focused_button)
	var focused_scroll_amount: int = scroll_container.scroll_vertical
	scroll_container.scroll_vertical = previous_scroll_amount

	return focused_scroll_amount


#####################
## SIGNALS CALLBACKS
#####################

# Manual handling of scrolling; set `Follow Focus` check off in `ScrollContainer`
func _on_button_focused() -> void:
	var focused_button := get_viewport().gui_get_focus_owner()

	if not focused_button in button_container.get_children():
		return

	var focused_scroll_amount := get_focused_scroll_amount()

	var tween := create_tween()
	tween.tween_property(
		scroll_container, "scroll_vertical", focused_scroll_amount, 0.1
	).from_current()

