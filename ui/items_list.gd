extends ScrollList
class_name ItemsList

#############
## VARIABLES
#############

var inventory: Inventory = ReferenceStash.inventory

#############
## OVERRIDES
#############

func _ready():
	fill(inventory.items)
	inventory.item_added.connect(_on_item_added)
	inventory.item_changed.connect(_on_item_changed)
	inventory.item_removed.connect(_on_item_removed)


###########
## METHODS
###########

func update_item_button_text(button: ResourceButton) -> void:
	button.text = button.resource.name


#####################
## SIGNALS CALLBACKS
#####################

func _on_item_added(_item_index: int, item: Item) -> void:
	var item_button: ResourceButton = add_resource_button()
	item_button.resource = item
	update_item_button_text(item_button)


func _on_item_changed(item_index: int, item: Item) -> void:
	var item_button: ResourceButton = button_container.get_child(item_index)
	item_button.resource = item
	update_item_button_text(item_button)


func _on_item_removed(item_index: int) -> void:
	var item_button: ResourceButton = button_container.get_child(item_index)

	item_button.queue_free()

	focus_nodes.remove_at(item_index)
