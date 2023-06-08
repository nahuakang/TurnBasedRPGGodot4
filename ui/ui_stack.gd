############################################################
## UIStack keeps track of the menus that have been in focus
## and handles grabbing/releasing focus on these menus.
############################################################

extends Resource
class_name UIStack

#############
## VARIABLES
#############

var uis: Array[FocusMenu] = []

###########
## SIGNALS
###########

signal ui_popped(ui)
signal ui_stack_empty


###########
## METHODS
###########

func push(ui_to_push: FocusMenu) -> void:
	if not empty():
		# Release focus on the current top UI
		uis.back().release_menu_focus()

	uis.append(ui_to_push)
	ui_to_push.show() # Must show UI first or `grab_focus` won't work
	ui_to_push.grab_menu_focus()


func pop() -> FocusMenu:
	if empty():
		return null

	var ui_to_pop: FocusMenu = uis.pop_back()
	ui_to_pop.release_menu_focus() # Must release focus before hiding UI
	ui_to_pop.hide()

	if not empty():
		uis.back().show()
		uis.back().grab_menu_focus()

	ui_popped.emit(ui_to_pop)

	if empty():
		ui_stack_empty.emit()

	return ui_to_pop


func hide_uis() -> void:
	for ui in uis:
		ui.hide()


func clear() -> void:
	hide_uis()
	uis.clear()


func empty() -> bool:
	return uis.is_empty()
