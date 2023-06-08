extends Control

#############
## VARIABLES
#############

@onready var battle_menu: BattleMenu = %BattleMenu
@onready var action_list: ScrollList = %ActionList
@onready var item_list: ScrollList = %ItemList

var elizabeth_stats: PlayerClassStats = ReferenceStash.elizabeth_stats

#############
## OVERRIDES
#############

func _ready():
	action_list.fill(elizabeth_stats.battle_actions)
	item_list.fill(elizabeth_stats.inventory.items)

	await battle_menu.show_menu()
	battle_menu.grab_menu_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# Release before hide, otherwise `gui_get_focus_owner()` might return null
		action_list.release_menu_focus()
		action_list.hide()

		# Release before hide, otherwise `gui_get_focus_owner()` might return null
		item_list.release_menu_focus()
		item_list.hide()

		battle_menu.grab_menu_focus()


#####################
## SIGNALS CALLBACKS
#####################

func _on_battle_menu_menu_option_selected(option: int) -> void:
	match option:
		BattleMenu.MENU_OPTION.ACTION:
			battle_menu.release_menu_focus()
			action_list.show()
			action_list.grab_menu_focus()

		BattleMenu.MENU_OPTION.ITEM:
			battle_menu.release_menu_focus()
			item_list.show()
			item_list.grab_menu_focus()


func _on_action_list_resource_selected(resource: BattleAction):
	print(resource.name)


func _on_item_list_resource_selected(resource: Item):
	print(resource.name)
