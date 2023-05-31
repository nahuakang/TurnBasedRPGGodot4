extends CharacterBody2D

#############
## VARIABLES
#############

@onready var animated_player := $AnimatedSprite2D
@onready var interactable_detector: Area2D = $InteractableDetector

#############
## CONSTANTS
#############

const SPEED: float = 100.0

#############
## OVERRIDES
#############

func _ready() -> void:
	# Set the default InteractableDetector rotation to facing down
	interactable_detector.rotation = Vector2.DOWN.angle()


func _physics_process(_delta: float) -> void:
	move_player()
	animate_player()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		var interactables: Array = interactable_detector.get_overlapping_bodies()

		for interactable in interactables:
			if not interactable is Interactable:
				continue

			interactable._run_interaction()
			get_viewport().set_input_as_handled()


###########
## METHODS
###########

func move_player() -> void:
	var movement := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = movement * SPEED

	move_and_slide()


func animate_player() -> void:
	if is_moving():
		animate_walk()
		# Rotate the InteractableDetector based on the velocity's angle
		interactable_detector.rotation = velocity.angle()
	else:
		animate_idle()


func animate_walk() -> void:
	var angle_rad := velocity.angle()
	var angle_deg := rad_to_deg(angle_rad)
	var rounded_angle_deg := int(round(angle_deg / 45) * 45)

	match rounded_angle_deg:
		180, 135, -135: animated_player.play("walk_left")
		45, 0, -45: animated_player.play("walk_right")
		-90: animated_player.play("walk_up")
		90: animated_player.play("walk_down")


func animate_idle() -> void:
	match animated_player.animation:
		"walk_left": animated_player.play("idle_left")
		"walk_right": animated_player.play("idle_right")
		"walk_up": animated_player.play("idle_up")
		"walk_down": animated_player.play("idle_down")


func is_moving() -> bool:
	return velocity != Vector2.ZERO
