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
	battle_menu.grab_action_focus()


#####################
## SIGNALS CALLBACKS
#####################

func _on_battle_menu_menu_option_selected(option: int) -> void:
	match option:
		BattleMenu.MENU_OPTION.ACTION:
			action_list.show()
			action_list.grab_button_focus()

		BattleMenu.MENU_OPTION.ITEM:
			item_list.show()
			item_list.grab_button_focus()


func _on_action_list_resource_selected(resource: BattleAction):
	print(resource.name)


func _on_item_list_resource_selected(resource: Item):
	print(resource.name)
