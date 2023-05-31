extends Resource
class_name Item

###########
## EXPORTS
###########

@export var name: String
@export_multiline var description: String
@export var amount: int: set = set_amount
@export var overworld_sprite: Texture

###########
## METHODS
###########

func set_amount(value: int) -> void:
	amount = value
