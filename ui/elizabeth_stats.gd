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
	stats.health_changed.connect(_on_health_changed)
	update_stats()


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

