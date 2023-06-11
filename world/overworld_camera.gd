extends Camera2D
class_name OverworldCamera


#############
## OVERRIDES
#############

func _ready():
	Events.request_update_camera_limits.connect(_on_request_update_camera_limits)


#####################
## SIGNALS CALLBACKS
#####################

func _on_request_update_camera_limits(limits: Rect2) -> void:
	limit_left = limits.position.x
	limit_right = limits.end.x
	limit_top = limits.position.y
	limit_bottom = limits.end.y
