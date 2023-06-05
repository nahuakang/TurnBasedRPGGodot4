extends Sprite2D

###########
## EXPORTS
###########

@export var encounters: Array[ClassStats] = []

#############
## OVERRIDES
#############

func _ready() -> void:
	randomize()
	ReferenceStash.random_encounters = encounters
	hide()


func _exit_tree() -> void:
	ReferenceStash.random_encounters = []

	# Request that `_ready` be called the next time this node enters the scene tree
	# This way, we randomize and reset the ReferenceStash.random_encounters
	request_ready()
