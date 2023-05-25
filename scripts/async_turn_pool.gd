extends Resource
class_name AsyncTurnPool

#############
## VARIABLES
#############

var active_nodes: Array[Node] = []

###########
## SIGNALS
###########

signal turn_over

###########
## METHODS
###########

func add(node: Node) -> void:
	active_nodes.append(node)


func remove(node: Node) -> void:
	active_nodes.erase(node)
	if active_nodes.is_empty():
		turn_over.emit()
