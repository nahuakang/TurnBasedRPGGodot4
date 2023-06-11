extends ColorRect
class_name CameraLimits

#############
## OVERRIDES
#############

func _ready():
	var camera_limits := Rect2(self.global_position, self.size)
	Events.request_update_camera_limits.emit(camera_limits)
	hide()
