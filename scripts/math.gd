extends Node
class_name Math

###########
## METHODS
###########

static func chance(percent: float) -> bool:
	return randf() <= percent
