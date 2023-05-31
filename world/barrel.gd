extends Interactable

#############
## OVERRIDES
#############

func _run_interaction() -> void:
	Events.request_show_message.emit("It's just a barrel...")
