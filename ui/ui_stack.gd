############################################################
## UIStack keeps track of the menus that have been in focus
## and handles grabbing/releasing focus on these menus.
############################################################

extends Resource
class_name UIStack

#############
## VARIABLES
#############

var uis: Array[Control] = []

###########
## SIGNALS
###########

signal ui_popped(ui)
signal ui_stack_empty

###########
## METHODS
###########

func push(ui_to_push: Control) -> void:
	if not empty():
		if uis.back() is FocusMenu:
			# Release focus on the current top UI
			uis.back().release_menu_focus()
		elif uis.back() is Control:
			uis.back().release_focus()

	uis.append(ui_to_push)
	ui_to_push.show() # Must show UI first or `grab_focus` won't work

	if ui_to_push is FocusMenu:
		ui_to_push.grab_menu_focus()
	elif ui_to_push is Control:
		ui_to_push.grab_focus()


func pop() -> Control:
	if empty():
		return null

	var ui_to_pop = uis.pop_back()

	if ui_to_pop is FocusMenu:
		ui_to_pop.release_menu_focus() # Must release focus before hiding UI
	elif ui_to_pop is Control:
		ui_to_pop.release_focus()

	ui_to_pop.hide()

	if not empty():
		uis.back().show()

		if uis.back() is FocusMenu:
			uis.back().grab_menu_focus()
		elif uis.back() is Control:
			uis.back().grab_focus()

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
