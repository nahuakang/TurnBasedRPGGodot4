extends Node

#############
## VARIABLES
#############

var data: Dictionary = {}

###########
## METHODS
###########

func get_id(node: Node) -> String:
	var main: Node = get_tree().current_scene

	return main.name + "_" + node.name + "_" + str(node.global_position)


func stash(id: String, key: String, value: Variant) -> void:
	data[id] = {}
	data[id][key] = value


func retrieve(id: String, key: String) -> Variant:
	if not data.has(id):
		return null

	if not data[id].has(key):
		return null

	return data[id][key]
