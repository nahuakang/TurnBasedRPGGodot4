extends CharacterBody2D

@onready var animated_player := $AnimatedSprite2D

const SPEED: float = 100.0


func _physics_process(_delta: float) -> void:
	move_player()
	animate_player()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		SceneStack.push("res://battle/battle.tscn")


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
