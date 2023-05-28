extends TextureRect
class_name LevelUpUI

#############
## VARIABLES
#############

@onready var experience_bar: ValueBar = %ExperienceBar

#############
## OVERRIDES
#############

#func _ready() -> void:
#	level_up()

###########
## METHODS
###########

func level_up() -> void:
	show()
	# TODO: These are hard-coded values
	experience_bar.set_bar(75, 100)
	await experience_bar.animate_bar(100, 100)
