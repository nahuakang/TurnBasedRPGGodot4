extends FocusMenu
class_name OverworldMenu

#########
## ENUMS
#########

enum OverworldMenuOption {
	STATS,
	ITEMS,
	EXIT,
}

###########
## SIGNALS
###########

signal option_selected(option: OverworldMenuOption)

#####################
## SIGNALS CALLBACKS
#####################

func _on_stats_button_button_down():
	option_selected.emit(OverworldMenuOption.STATS)


func _on_items_button_button_down():
	option_selected.emit(OverworldMenuOption.ITEMS)


func _on_exit_button_button_down():
	option_selected.emit(OverworldMenuOption.EXIT)
