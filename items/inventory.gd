extends Resource
class_name Inventory

###########
## EXPORTS
###########

@export var items: Array[Resource]

###########
## SIGNALS
###########

signal item_added(item_index: int, item: Resource)
signal item_changed(item_index: int, item: Resource)
signal item_removed(item_index: int)

###########
## METHODS
###########

func add_item(item: Item, amount: int = 1) -> void:
	var item_index := items.find(item)

	# Did not find the item in the array
	if item_index == -1:
		items.append(item)
		item.amount = amount
		item_index = items.size() - 1
		# Signal emit
		item_added.emit(item_index, item)

	else:
		items[item_index].amount += amount
		# Signal emit
		item_changed.emit(item_index, item)


func remove_item(item: Item, amount: int = 1) -> Item:
	var item_index := items.find(item)

	# Did not find the item in the array
	if item_index == -1:
		return null

	item.amount -= 1
	item_changed.emit(item_index, item)

	# If the item count is 0
	if item.amount <= 0:
		items.erase(item)
		item_removed.emit(item_index)

	return item
