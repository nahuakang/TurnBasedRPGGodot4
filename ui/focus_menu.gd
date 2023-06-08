extends Control
class_name FocusMenu

###########
## EXPORTS
###########

@export var focus_nodes: Array[NodePath]

#############
## VARIABLES
#############

var last_focus_node: Control

###########
## METHODS
###########

func grab_menu_focus() -> void:
	if not can_grab_focus():
		return

	set_menu_focus_mode(Control.FOCUS_ALL)

	if is_instance_valid(last_focus_node) and last_focus_node is Control:
		last_focus_node.grab_focus()
		return

	var focus_node = get_node(focus_nodes.front())
	focus_node.grab_focus()


func release_menu_focus() -> void:
	var current_focus: Control = get_viewport().gui_get_focus_owner()
	if not current_focus is Control:
		return

	# Remember the last focus node
	last_focus_node	= current_focus
	current_focus.release_focus()

	set_menu_focus_mode(Control.FOCUS_NONE)


func set_menu_focus_mode(mode: Control.FocusMode) -> void:
	for focus_node_path in focus_nodes:
		var focus_node: Control = get_node(focus_node_path)
		focus_node.focus_mode = mode


func can_grab_focus() -> bool:
	return (
		is_instance_valid(last_focus_node)
		and last_focus_node is Control
		or not focus_nodes.is_empty()
	)
