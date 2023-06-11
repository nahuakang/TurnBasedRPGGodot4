extends PanelContainer

#############
## VARIABLES
#############

@onready var level: Label = %Level
@onready var health_bar: ValueBar = %HealthBar
@onready var experience_bar: ValueBar = %ExperienceBar

var stats: PlayerClassStats = ReferenceStash.elizabeth_stats

###########
## SIGNALS
###########

signal animation_finished

#############
## OVERRIDES
#############

func _ready() -> void:
	if not stats.health_changed.is_connected(_on_health_changed):
		stats.health_changed.connect(_on_health_changed)

	update_stats()


func _exit_tree() -> void:
	# Ensure that the next time `elizabeth_stats` enters the scene tree,
	# we re-run `_ready` to update the stats
	request_ready()


###########
## METHODS
###########

func update_stats() -> void:
	level.text = "Level: " + str(stats.level)
	health_bar.set_bar(stats.health, stats.max_health)
	experience_bar.set_bar(stats.experience, stats.MAX_EXPERIENCE)


#####################
## SIGNALS CALLBACKS
#####################

func _on_health_changed() -> void:
	health_bar.animate_bar(stats.health, stats.max_health)
	await health_bar.animation_finished
	animation_finished.emit()

