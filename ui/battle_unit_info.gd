extends Control
class_name BattleUnitInfo

#############
## VARIABLES
#############

@onready var health_bar: ValueBar = $HealthBar

var stats: ClassStats: set = set_stats

###########
## METHODS
###########

func set_stats(value: ClassStats) -> void:
	stats = value
	connect_stats()


func connect_stats() -> void:
	if not stats is ClassStats:
		return

	stats.health_changed.connect(_on_stats_health_changed)
	health_bar.set_bar(stats.health, stats.max_health)

##################
## SIGNAL METHODS
##################

func _on_stats_health_changed() -> void:
	health_bar.animate_bar(stats.health, stats.max_health)
