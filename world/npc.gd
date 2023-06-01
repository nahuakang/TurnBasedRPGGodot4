extends Interactable
class_name NPC

###########
## EXPORTS
###########

@export var character: Character

#############
## OVERRIDES
#############

func _run_interaction() -> void:
	Events.request_show_dialog.emit("Aaaahhh! I have a headache.", character)
	await Events.dialog_finished

	Events.request_show_dialog.emit("Can you find a potion?", character)
	await Events.dialog_finished

	Events.request_show_dialog.emit(
		"I'll look around for you.",
		load("res://characters/elizabeth_character.tres"))
	await Events.dialog_finished
