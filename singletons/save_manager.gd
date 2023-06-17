extends Node

#############
## CONSTANTS
#############

const TEST_PATH: String = "res://save.json"
const SAVE_PATH: String = "user://save.json"

#############
## VARIABLES
#############

var data = {  }

###########
## METHODS
###########

func save_game() -> void:
	var file = FileAccess.open(TEST_PATH, FileAccess.WRITE)
	if file == null:
		return

	var stats: PlayerClassStats = ReferenceStash.elizabeth_stats
	var inventory: Inventory = ReferenceStash.inventory
	var world_data: Dictionary = WorldStash.data
	var player_global_position: Vector2 = ReferenceStash.player.global_position

	var save_data: Dictionary = {
		"current_scene": get_tree().current_scene.scene_file_path,
		"player": {
			"x": player_global_position.x,
			"y": player_global_position.y,
		},
		"stats": {
			"level": stats.level,
			"health": stats.health,
			"experience": stats.experience,
		},
		"inventory": [],
		"world_data": world_data,
	}

	for item in inventory.items:
		save_data.inventory.append({
			"resource_path": item.resource_path,
			"amount": item.amount,
		})

	var data_string: String = JSON.stringify(save_data)
	print(data_string)

	file.store_string(data_string)
	file.close()


func load_game() -> void:
	var file = FileAccess.open(TEST_PATH, FileAccess.READ)
	if file == null:
		return

	var data_string = file.get_as_text()
	file.close()

	var json: JSON = JSON.new()

	if not json.parse(data_string) == OK:
		return

	var load_data: Dictionary = json.data
	WorldStash.data = load_data.world_data

	var stats: PlayerClassStats = ReferenceStash.elizabeth_stats
	stats.level = load_data.stats.level
	stats.health = load_data.stats.health
	stats.experience = load_data.stats.experience

	var inventory: Inventory = ReferenceStash.inventory
	inventory.items.clear()

	for item_data in load_data.inventory:
		var item: Item = load(item_data.resource_path)
		inventory.add_item(item, item_data.amount)

	if not ReferenceStash.player is OverworldPlayer:
		var player: OverworldPlayer = load("res://world/overworld_player.tscn").instantiate()
		LevelSwapper.player = player
		ReferenceStash.player = player

	var player = ReferenceStash.player as OverworldPlayer
	player.last_door_connection = -1
	await Transition.fade_to_color(Color.BLACK)
	LevelSwapper.level_swap(player, load_data.current_scene)
	Transition.fade_from_color(Color.BLACK)
	player.global_position = Vector2(load_data.player.x, load_data.player.y)
