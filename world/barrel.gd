extends Interactable

###########
## EXPORTS
###########

@export var item: Item

#############
## VARIABLES
#############

@onready var id: String = WorldStash.get_id(self)

var inventory: Inventory = ReferenceStash.inventory

#############
## OVERRIDES
#############

func _ready() -> void:
	if WorldStash.retrieve(id, "item") == "empty":
		item = null


func _run_interaction() -> void:
	if item is Item:
		inventory.add_item(item)
		Events.request_show_message.emit("You found a " + item.name + ".")
		item = null
		WorldStash.stash(id, "item", "empty")

	else:
		Events.request_show_message.emit("It's just a barrel...")
