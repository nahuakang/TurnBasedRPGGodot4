extends Control

#############
## VARIABLES
#############

@onready var battle_menu: BattleMenu = %BattleMenu
@onready var action_list: ScrollList = %ActionList
@onready var item_list: ScrollList = %ItemList
@onready var context_menu: ContextMenu = %ContextMenu

var elizabeth_stats: PlayerClassStats = ReferenceStash.elizabeth_stats
var ui_stack := UIStack.new()

#############
## OVERRIDES
#############

func _ready():
	action_list.fill(elizabeth_stats.battle_actions)
	item_list.fill(elizabeth_stats.inventory.items)

	await battle_menu.show_menu()
	ui_stack.push(battle_menu)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		ui_stack.pop()


#####################
## SIGNALS CALLBACKS
#####################

func _on_battle_menu_menu_option_selected(option: int) -> void:
	match option:
		BattleMenu.MENU_OPTION.ACTION:
			ui_stack.push(action_list)

		BattleMenu.MENU_OPTION.ITEM:
			ui_stack.push(item_list)


func _on_action_list_resource_selected(resource: BattleAction) -> void:
	ui_stack.push(context_menu)
	print(resource.name)


func _on_item_list_resource_selected(resource: Item) -> void:
	ui_stack.push(context_menu)
	print(resource.name)


func _on_context_menu_option_selected(option: ContextMenu.CONTEXT_OPTION) -> void:
	match option:
		ContextMenu.CONTEXT_OPTION.USE:
			print("USE")
		ContextMenu.CONTEXT_OPTION.INFO:
			print("INFO")
