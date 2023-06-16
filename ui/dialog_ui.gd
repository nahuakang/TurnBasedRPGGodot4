extends TextureRect

#############
## CONSTANTS
#############

const CHAR_DISPLAY_DURATION: float = 0.08

#############
## VARIABLES
#############
@onready var text_box: RichTextLabel = %TextBox
@onready var portrait: TextureRect = %Portrait
@onready var voice: AudioStreamPlayer = $Voice

var typer: Tween
var is_typing: bool = false
var pitch: float = 1.0

#############
## OVERRIDES
#############

func _ready() -> void:
	# This node should always process, even when game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

	Events.request_show_dialog.connect(type_dialog)


func _unhandled_input(event) -> void:
	# Only handle input when visible
	if not visible:
		return

	if not event.is_action_pressed("ui_accept"):
		return

	if is_typing:
		is_typing = false

		if typer is Tween:
			typer.kill()

		text_box.visible_ratio = 1.0
	else:
		hide()
		get_viewport().set_input_as_handled()
		get_tree().paused = false

		Events.dialog_finished.emit()


###########
## METHODS
###########

func type_dialog(bbcode: String, character: Character) -> void:
	is_typing = true
	get_tree().paused = true

	show()

	text_box.text = bbcode
	portrait.texture = character.portrait
	pitch = character.voice_pitch

	# Must await so that `get_total_character_count` can be correct without
	# extra BBCode
#	await get_tree().process_frame

	var total_characters: int = text_box.text.length()
	var duration: float = total_characters * CHAR_DISPLAY_DURATION

	typer = create_tween()
	typer.tween_method(set_visible_characters, 0, total_characters, duration)
	await typer.finished

	is_typing = false


func set_visible_characters(index: int) -> void:
	text_box.visible_characters = index

	var is_new_character: bool = index > text_box.visible_characters
	if is_new_character and index < text_box.get_total_character_count():
		var character = text_box.text.substr(text_box.visible_characters, 1)
		voice.pitch_scale = randf_range(pitch - 0.1, pitch + 0.1)
		voice.play()
