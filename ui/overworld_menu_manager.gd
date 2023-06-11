extends MarginContainer
class_name OverworldMenuManager

#############
## CONSTANTS
#############

const TIMER_DURATION: float = 0.25

#############
## VARIABLES
#############

@onready var context_menu: FocusMenu = %ContextMenu
@onready var elizabeth_stats: ElizabethStats = %ElizabethStats
@onready var info_menu: FocusMenu = %InfoMenu
@onready var items_list: FocusMenu = %ItemsList
@onready var overworld_menu: FocusMenu = %OverworldMenu
@onready var timer: Timer = $Timer

var inventory: Inventory = ReferenceStash.inventory
var item_resource: Item
var stats_resource: PlayerClassStats = ReferenceStash.elizabeth_stats
var ui_stack := UIStack.new()

#############
## OVERRIDES
#############

func _ready() -> void:
	Events.request_show_overworld_menu.connect(_on_request_show_overworld_menu)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not ui_stack.empty():
			ui_stack.pop()

			if ui_stack.empty():
				get_viewport().set_input_as_handled()
				get_tree().paused = false


###########
## METHODS
###########

func use_healing_item(item: HealingItem) -> void:
	set_process_unhandled_input(false)

	ui_stack.pop() # Hide the context menu
	ui_stack.pop() # Hide the items list
	ui_stack.push(elizabeth_stats)
	inventory.remove_item(item)
	stats_resource.health += item.heal_amount

	await elizabeth_stats.animation_finished

	timer.start(TIMER_DURATION)
	await timer.timeout
	ui_stack.pop() # Hide the stats
	ui_stack.push(items_list) # Return to the items list

	set_process_unhandled_input(true)


#####################
## SIGNALS CALLBACKS
#####################

func _on_overworld_menu_option_selected(option: OverworldMenu.OverworldMenuOption) -> void:
	match option:
		OverworldMenu.OverworldMenuOption.STATS:
			ui_stack.push(elizabeth_stats)

		OverworldMenu.OverworldMenuOption.ITEMS:
			ui_stack.push(items_list)

		OverworldMenu.OverworldMenuOption.EXIT:
			ui_stack.pop()
			get_tree().paused = false


func _on_items_list_resource_selected(resource: Item) -> void:
	item_resource = resource
	ui_stack.push(context_menu)


func _on_context_menu_option_selected(option: ContextMenu.CONTEXT_OPTION) -> void:
	match option:
		ContextMenu.CONTEXT_OPTION.USE:
			if item_resource is HealingItem:
				if stats_resource.health < stats_resource.max_health:
					use_healing_item(item_resource)
				else:
					info_menu.text = "Your health is already full."
					ui_stack.push(info_menu)

		ContextMenu.CONTEXT_OPTION.INFO:
			info_menu.text = item_resource.description
			ui_stack.push(info_menu)


func _on_request_show_overworld_menu() -> void:
	ui_stack.push(overworld_menu)
	get_tree().paused = true
