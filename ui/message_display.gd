extends CenterContainer

#############
## VARIABLES
#############

@onready var label = %Label

#############
## OVERRIDES
#############

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Process the message display even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	Events.request_show_message.connect(show_message)


func _unhandled_input(event: InputEvent) -> void:
	if not visible: return

	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		# Stop the input from propagating down the scene tree
		get_viewport().set_input_as_handled()
		hide()

###########
## METHODS
###########

func show_message(message: String) -> void:
	show()
	get_tree().paused = true
	label.text = message
