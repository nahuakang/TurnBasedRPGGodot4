extends Interactable

#############
## CONSTANTS
#############

const PICKUP_SOUND_DURATION: float = 0.3

#############
## VARIABLES
#############

@onready var pickup_sound: AudioStreamPlayer = $PickupSound
@onready var pickup_sound_timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D
@onready var id := WorldStash.get_id(self)

var inventory: Inventory = ReferenceStash.inventory

###########
## EXPORTS
###########

@export var item: Item : set = set_item

#############
## OVERRIDES
#############

func _ready() -> void:
	if WorldStash.retrieve(id, "freed"):
		queue_free()


func _run_interaction() -> void:
	inventory.add_item(item)

	pickup_sound_timer.start(PICKUP_SOUND_DURATION)
	pickup_sound.play()
	await pickup_sound_timer.timeout

	Events.request_show_message.emit("You found a " + item.name + ".")

	# Stash the pickup info and remove the item upon interaction
	WorldStash.stash(id, "freed", true)
	queue_free()


###########
## METHODS
###########

func set_sprite_texture(item_candidate: Item) -> void:
	if not sprite:
		return

	sprite.texture = item_candidate.overworld_texture


###########
## SETTERS
###########

func set_item(value: Item) -> void:
	item = value

	call_deferred("set_sprite_texture", item)
