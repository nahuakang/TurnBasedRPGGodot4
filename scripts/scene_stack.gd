extends Node

var stack: Array[Node] = []

# Push `new_scene_path` to the scene tree and root as the new active scene
# and store the current active scene into `SceneStack.stack`
func push(new_scene_path: String) -> void:
	var tree := get_tree()
	var root := tree.get_root()

	var current_scene := tree.get_current_scene()
	stack.append(current_scene)
	root.remove_child(current_scene)

	var new_scene: Node = load(new_scene_path).instantiate()
	root.add_child(new_scene)
	tree.set_current_scene(new_scene)


# Pop and free the current active scene from the scene tree
# and set the most recent scene in `SceneStack.stack` as active scene
func pop() -> void:
	if stack.is_empty():
		return

	var tree := get_tree()
	var root := tree.get_root()

	tree.get_current_scene().queue_free()
	var previous_scene: Node = stack.pop_back()
	root.add_child(previous_scene)
	tree.set_current_scene(previous_scene)


# Clear all scenes in `SceneStack.stack`
func clear() -> void:
	for scene in stack:
		scene.queue_free()
	stack.clear()
