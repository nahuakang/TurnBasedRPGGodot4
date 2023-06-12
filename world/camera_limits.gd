## NOTE: For initial game startup, `CameraLimits` must be placed below
## `OverworldPlayer` so othat the `_ready` call order has already connected
## the signal to a callback before `request_update_camera_limits.emit` is called.
extends ColorRect
class_name CameraLimits

#############
## OVERRIDES
#############

func _ready():
	var camera_limits := Rect2(self.global_position, self.size)
	Events.request_update_camera_limits.emit(camera_limits)
	hide()
