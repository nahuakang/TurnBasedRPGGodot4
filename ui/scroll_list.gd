extends PanelContainer
class_name ScrollList

#############
## CONSTANTS
#############

const RESOURCE_BUTTON_SCENE: PackedScene = preload("res://ui/resource_button.tscn")

#############
## VARIABLES
#############

@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var button_container: VBoxContainer = %ButtonContainer

###########
## SIGNALS
###########

signal resource_selected(resource: Resource)

#############
## OVERRIDES
#############

func _ready():
	pass
#	fill(elizabeth_stats.battle_actions)
#	connect_scroll_children()


###########
## METHODS
###########

func fill(resource_list: Array[Resource]) -> void:
	for resource in resource_list:
		var resource_button: ResourceButton = add_resource_button()
		resource_button.resource = resource
		resource_button.text = resource.name

	connect_scroll_children()


func add_resource_button() -> ResourceButton:
	var resource_button: ResourceButton = RESOURCE_BUTTON_SCENE.instantiate()
	button_container.add_child(resource_button)
	resource_button.resource_selected.connect(_on_resource_selected)
	return resource_button


func clear() -> void:
	for button in button_container.get_children():
		button.queue_free()


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


func grab_button_focus() -> void:
	button_container.get_child(0).grab_focus()

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


func _on_resource_selected(resource: Resource) -> void:
	resource_selected.emit(resource)
