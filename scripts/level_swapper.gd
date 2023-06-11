extends Node

#############
## VARIABLES
#############

var player: CharacterBody2D

###########
## METHODS
###########

func stash_player(player_to_stash: CharacterBody2D) -> void:
	player = player_to_stash
	player.get_parent().remove_child(player)


func drop_player() -> void:
	await get_tree().process_frame
	var parent := get_tree().current_scene
	parent.add_child(player)
	player.owner = parent


func level_swap(player_to_stash: CharacterBody2D, new_level_string: String) -> void:
	stash_player(player_to_stash)
	get_tree().change_scene_to_file(new_level_string)
	drop_player()

