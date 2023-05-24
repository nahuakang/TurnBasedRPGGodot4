extends Node2D
class_name BattleUnit

# Can also use:
#@export_file("*.tscn") var battle_animations_scene_path: String
@export var battle_animations_scene: PackedScene

var battle_animations: BattleAnimations

#############
## OVERRIDES
#############

func _ready() -> void:
	# `PackedScene.instantiate` returns a `Node`, which `BattleAnimations` inherits
	battle_animations = battle_animations_scene.instantiate()
	add_child(battle_animations)


###########
## METHODS
###########

func melee_attack() -> void:
	print("Melee attack!")
