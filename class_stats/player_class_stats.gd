extends ClassStats
class_name PlayerClassStats

#############
## CONSTANTS
#############

const MAX_EXPERIENCE: int = 100

#############
## VARIABLES
#############

var experience: int = 0: set = set_experience

###########
## METHODS
###########

func set_experience(value: int) -> void:
	experience = value

	# Check for leveling up
	while experience > MAX_EXPERIENCE:
		experience = experience - MAX_EXPERIENCE
		level += 1
