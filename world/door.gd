extends Area2D
class_name Door

#############
## VARIABLES
#############

@onready var drop_point: Marker2D = $DropPoint

###########
## EXPORTS
###########

@export_file("*.tscn") var new_area
@export_range(0, 32) var connection: int
