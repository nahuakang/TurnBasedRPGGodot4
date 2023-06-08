extends Control
class_name BattleMenuManager

#############
## CONSTANTS
#############

const RUN_BATTLE_ACTION = preload("res://battle_actions/run_battle_action.tres")

#############
## VARIABLES
#############

@onready var battle_menu: BattleMenu = %BattleMenu
@onready var action_list: ScrollList = %ActionList
@onready var item_list: ScrollList = %ItemList
@onready var context_menu: ContextMenu = %ContextMenu
@onready var info_menu: InfoMenu = %InfoMenu

var elizabeth_stats: PlayerClassStats = ReferenceStash.elizabeth_stats
var inventory: Inventory = ReferenceStash.inventory
var ui_stack := UIStack.new()

var selected_resource: Resource

###########
## SIGNALS
###########

signal battle_menu_resource_selected(selected_resource: Resource)

#############
## OVERRIDES
#############

func _ready():
	action_list.fill(elizabeth_stats.battle_actions)
	item_list.fill(elizabeth_stats.inventory.items)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and ui_stack.uis.size() > 1:
		ui_stack.pop()


###########
## METHODS
###########

func show_battle_menu() -> void:
	await battle_menu.show_menu()
	ui_stack.push(battle_menu)


#####################
## SIGNALS CALLBACKS
#####################

func _on_battle_menu_menu_option_selected(option: int) -> void:
	match option:
		BattleMenu.MENU_OPTION.ACTION:
			ui_stack.push(action_list)

		BattleMenu.MENU_OPTION.ITEM:
			ui_stack.push(item_list)

		BattleMenu.MENU_OPTION.RUN:
			battle_menu_resource_selected.emit(RUN_BATTLE_ACTION)


func _on_action_list_resource_selected(resource: BattleAction) -> void:
	ui_stack.push(context_menu)
	selected_resource = resource


func _on_item_list_resource_selected(resource: Item) -> void:
	ui_stack.push(context_menu)
	selected_resource = resource


func _on_context_menu_option_selected(option: ContextMenu.CONTEXT_OPTION) -> void:
	match option:
		ContextMenu.CONTEXT_OPTION.USE:
			ui_stack.clear()
			battle_menu.show()
			battle_menu.hide_menu()

			if selected_resource is Item:
				inventory.remove_item(selected_resource)

			battle_menu_resource_selected.emit(selected_resource)

		ContextMenu.CONTEXT_OPTION.INFO:
			if selected_resource is Item or selected_resource is BattleAction:
				info_menu.text = selected_resource.description
				ui_stack.push(info_menu)
