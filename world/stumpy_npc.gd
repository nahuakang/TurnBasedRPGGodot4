extends NPC

#############
## CONSTANTS
#############

const ELIZABETH_CHARACTER: Character = preload("res://characters/elizabeth_character.tres")
const APPLE_ITEM: Item = preload("res://items/apple_item.tres")

#############
## VARIABLES
#############

@onready var id: String = WorldStash.get_id(self)

var inventory := ReferenceStash.inventory
var has_apple := false

#############
## OVERRIDES
#############

func _ready() -> void:
	if WorldStash.retrieve(id, "has_apple"):
		has_apple = true


func _run_interaction() -> void:
	if not has_apple:
		Events.request_show_dialog.emit("Aaaahhh! I have a headache.", character)
		await Events.dialog_finished

		Events.request_show_dialog.emit("Do you have an apple I can eat?", character)
		await Events.dialog_finished

		var apple := inventory.remove_item(APPLE_ITEM)
		if apple is Item:
			Events.request_show_dialog.emit("I do.", ELIZABETH_CHARACTER)
			await Events.dialog_finished

			Events.request_show_dialog.emit("Here it is.", ELIZABETH_CHARACTER)
			await Events.dialog_finished

			has_apple = true
			WorldStash.stash(id, "has_apple", true)

		else:
			Events.request_show_dialog.emit("I'll look around for you.", ELIZABETH_CHARACTER)
			await Events.dialog_finished

	if has_apple:
		Events.request_show_dialog.emit("I feel much better now. ", character)
		await Events.dialog_finished

		Events.request_show_dialog.emit("Thank you!", character)
		await Events.dialog_finished

		Events.request_show_dialog.emit("You're welcome.", ELIZABETH_CHARACTER)
		await Events.dialog_finished
