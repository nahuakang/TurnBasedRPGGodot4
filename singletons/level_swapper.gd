extends Node

#############
## VARIABLES
#############

var player: OverworldPlayer

###########
## METHODS
###########

func stash_player(player_to_stash: OverworldPlayer) -> void:
	player = player_to_stash
	player.get_parent().remove_child(player)


func drop_player() -> void:
	await get_tree().process_frame
	var parent := get_tree().current_scene
	parent.add_child(player)
	player.owner = parent

	for door in get_tree().get_nodes_in_group("doors"):
		door = door as Door
		if door.connection != player.last_door_connection:
			continue

		player.global_position = door.drop_point.global_position


func level_swap(player_to_stash: OverworldPlayer, new_level_string: String) -> void:
	stash_player(player_to_stash)
	get_tree().change_scene_to_file(new_level_string)
	drop_player()

