extends Button
class_name ParentButton

##############
## VARAIABLES
##############

@onready var focus_sound: AudioStreamPlayer = $FocusSound
@onready var select_sound: AudioStreamPlayer = $SelectSound

#####################
## SIGNALS CALLBACKS
#####################

func _on_focus_entered():
	focus_sound.play()


func _on_button_down():
	select_sound.play()
