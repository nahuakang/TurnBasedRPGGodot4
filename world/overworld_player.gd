extends CharacterBody2D
class_name OverworldPlayer

#############
## CONSTANTS
#############

const SPEED: float = 100.0
const MAX_ENCOUNTER_METER: float = 100.0
const MIN_ENCOUNTER_CHANCE: float = 0.1
const ENCOUNTER_CHANCE_DELTA: float = 0.1
const ENCOUNTER_METER_REDUCTION_AMOUNT: float = 75.0

#############
## VARIABLES
#############

@onready var animated_player := $AnimatedSprite2D
@onready var interactable_detector: Area2D = $InteractableDetector

var encounter_meter := MAX_ENCOUNTER_METER
var encounter_chance := MIN_ENCOUNTER_CHANCE
var last_door_connection: int = -1

#############
## OVERRIDES
#############

func _init() -> void:
	# Free the instance of the player in case one exists in the level swapper already
	if LevelSwapper.player is OverworldPlayer:
		queue_free()


func _ready() -> void:
	# Set the default InteractableDetector rotation to facing down
	interactable_detector.rotation = Vector2.DOWN.angle()


func _physics_process(delta: float) -> void:
	move_player()
	animate_player(delta)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		var interactables: Array = interactable_detector.get_overlapping_bodies()

		for interactable in interactables:
			if not interactable is Interactable:
				continue

			interactable._run_interaction()
			get_viewport().set_input_as_handled()

	if event.is_action_pressed("ui_cancel"):
		Events.request_show_overworld_menu.emit()
		get_viewport().set_input_as_handled()


###########
## METHODS
###########

func move_player() -> void:
	var movement := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = movement * SPEED

	move_and_slide()


func animate_player(delta: float) -> void:
	if is_moving():
		animate_walk()
		# Rotate the InteractableDetector based on the velocity's angle
		interactable_detector.rotation = velocity.angle()

		encounter_check(delta)
	else:
		animate_idle()


func encounter() -> void:
	var random_encounters := ReferenceStash.random_encounters
	if random_encounters.is_empty():
		return

	random_encounters.shuffle()
	ReferenceStash.encounter_class = random_encounters.front()

	# If encounters, transition and enter battle scene
	get_tree().paused = true
	await Transition.fade_to_color(Color.WHITE)
	Transition.set_color(Color.TRANSPARENT)
	get_tree().paused = false
	SceneStack.push("res://battle/battle.tscn")


func encounter_check(delta: float) -> void:
	encounter_meter -= ENCOUNTER_METER_REDUCTION_AMOUNT * delta
	if encounter_meter <= 0:
		encounter_meter = MAX_ENCOUNTER_METER

		if Math.chance(encounter_chance):
			encounter_chance = MIN_ENCOUNTER_CHANCE
			encounter()

		else:
			encounter_chance = min(encounter_chance + ENCOUNTER_CHANCE_DELTA, 1.0)


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


func go_to_new_area(new_area_path: String) -> void:
	get_tree().paused = true
	await Transition.fade_to_color(Color.BLACK)
	get_tree().paused = false

	encounter_meter = MAX_ENCOUNTER_METER
	LevelSwapper.level_swap(self, new_area_path)

	await Transition.fade_from_color(Color.BLACK)

#####################
## SIGNALS CALLBACKS
#####################

func _on_door_detector_area_entered(door: Area2D) -> void:
	if not door is Door:
		return

	door = door as Door
	if door.new_area == null:
		return

	last_door_connection = door.connection
	call_deferred("go_to_new_area", door.new_area)
