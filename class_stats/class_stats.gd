extends Resource
class_name ClassStats

###########
## EXPORTS
###########

@export var name: String
@export var max_health: int: set = set_max_health # Used to set the `.tres` value
@export var attack: int
@export var defense: int
@export var battle_actions: Array[Resource]
@export var battle_animations: PackedScene

#############
## VARIABLES
#############

var level: int = 1
var health: int = 1: set = set_health

###########
## SIGNALS
###########

signal health_changed
signal health_depleted
signal level_changed
signal max_health_changed

###########
## METHODS
###########

func set_max_health(value: int) -> void:
	max_health = value
	max_health_changed.emit()
	set_health(max_health)


func set_health(value: int) -> void:
	health = clamp(value, 0, max_health)
	health_changed.emit()

	if health == 0:
		health_depleted.emit()
