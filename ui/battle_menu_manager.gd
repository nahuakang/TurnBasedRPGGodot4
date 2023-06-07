extends Control

#############
## VARIABLES
#############

@onready var battle_menu: BattleMenu = %BattleMenu
@onready var action_list: ScrollList = %ActionList
@onready var item_list: ScrollList = %ItemList

#############
## OVERRIDES
#############

func _ready():
	battle_menu.show_menu()
