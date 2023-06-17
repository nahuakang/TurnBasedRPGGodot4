extends Node

#############
## CONSTANTS
#############

const VOLUME_FADE_OUT_DURATION: float = 0.25
const VOLUME_FADE_IN_DURATION: float = 1.0

#############
## VARIABLES
#############

@onready var town_music: AudioStreamPlayer = $TownMusic
@onready var battle_music: AudioStreamPlayer = $BattleMusic

var stack: Array[AudioStreamPlayer] = []

###########
## METHODS
###########

func push_song(song: AudioStreamPlayer) -> void:
	if not stack.is_empty():
		var previous_song = stack.back() as AudioStreamPlayer
		previous_song.stream_paused = true

	stack.append(song)
	song.play()


func pop_song() -> void:
	if stack.is_empty():
		return

	var current_song = stack.pop_back() as AudioStreamPlayer
	var fade_out_volume = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	fade_out_volume.tween_property(current_song, "volume_db", -50.0, VOLUME_FADE_OUT_DURATION).from_current()
	await fade_out_volume.finished
	current_song.stop()
	current_song.volume_db = 0.0

	var last_song = stack.back() as AudioStreamPlayer
	last_song.volume_db = -50.0
	last_song.stream_paused = false
	var fade_in_volume = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	fade_in_volume.tween_property(last_song, "volume_db", 0.0, VOLUME_FADE_IN_DURATION).from_current()
