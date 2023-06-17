extends Node2D


func _ready():
	if MusicPlayer.stack.has(MusicPlayer.town_music):
		return

	MusicPlayer.push_song(MusicPlayer.town_music)
