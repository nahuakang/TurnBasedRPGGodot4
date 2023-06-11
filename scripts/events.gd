extends Node

###########
## SIGNALS
###########

signal dialog_finished
signal request_show_message(message: String)
signal request_show_dialog(message: String, character: Character)
signal request_show_overworld_menu
signal request_update_camera_limits(limits: Rect2)
