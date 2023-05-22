extends CharacterBody2D

@onready var animation_player = $Sprite2D/AnimationPlayer

const SPEED = 100.0


func _physics_process(delta):
	move_player()
	animate_player()


func move_player() -> void:
	var movement := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = movement * SPEED
	move_and_slide()


func animate_player() -> void:
	if is_moving():
		animate_walk()
	else:
		animate_idle()


func animate_walk() -> void:
	var angle_rad := velocity.angle()
	var angle_deg := rad_to_deg(angle_rad)
	var rounded_angle_deg := int(round(angle_deg / 45) * 45)

	match rounded_angle_deg:
		180, 135, -135: animation_player.play("walk_left")
		45, 0, -45: animation_player.play("walk_right")
		-90: animation_player.play("walk_up")
		90: animation_player.play("walk_down")

func animate_idle() -> void:
	match animation_player.current_animation:
		"walk_down": animation_player.play("idle_down")
		"walk_up": animation_player.play("idle_up")
		"walk_left": animation_player.play("idle_left")
		"walk_right": animation_player.play("idle_right")


func is_moving() -> bool:
	return velocity != Vector2.ZERO
