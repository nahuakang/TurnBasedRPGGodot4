extends Interactable

#############
## VARIABLES
#############

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
	pass


func _run_interaction() -> void:
	inventory.add_item(item)

	Events.request_show_message.emit("You found a " + item.name + ".")

	# Remove the item upon interaction
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
