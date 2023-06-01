extends Interactable

###########
## EXPORTS
###########

@export var item: Item

#############
## VARIABLES
#############

var inventory: Inventory = ReferenceStash.inventory

#############
## OVERRIDES
#############

func _run_interaction() -> void:
	if item is Item:
		inventory.add_item(item)
		Events.request_show_message.emit("You found a " + item.name + ".")
		item = null

	else:
		Events.request_show_message.emit("It's just a barrel...")
#		Events.request_show_dialog.emit("It's just a barrel", load("res://characters/elizabeth_character.tres"))
