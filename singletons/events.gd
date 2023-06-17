extends Node

###########
## SIGNALS
###########

# Camera
signal request_update_camera_limits(limits: Rect2)

# Dialog
signal dialog_finished
signal request_show_dialog(message: String, character: Character)

# UI Menus and Message
signal request_show_message(message: String)
signal request_show_overworld_menu
