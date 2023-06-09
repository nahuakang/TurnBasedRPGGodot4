extends Sprite2D
class_name BattleAnimations

#############
## VARIABLES
#############

# This assumes that the class has `AnimationPlayer` as child
@onready var animation_player: AnimationPlayer = $AnimationPlayer
# This is the emission point for the ranged attack
@onready var emission_point: Marker2D = $EmissionPoint

############
## SIGNALS
############

signal animation_finished

#############
## OVERRIDES
#############

func _ready():
	# Godot 3 syntax:
	# animation_player.connect("animation_finished", self, "emit_signal", ["animation_finished"])
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)


###########
## METHODS
###########

func play(animation_name: String) -> void:
	assert(animation_player.has_animation(animation_name))
	animation_player.play(animation_name)


func get_current_animation_length() -> float:
	# Account for the `Speed Scale` property on `AnimationPlayer`
	return animation_player.current_animation_length / animation_player.speed_scale


func get_emission_position() -> Vector2:
	return emission_point.global_position


#####################
## SIGNALS CALLBACKS
#####################

func _on_animation_player_animation_finished(_anim_name: String) -> void:
	animation_finished.emit()
