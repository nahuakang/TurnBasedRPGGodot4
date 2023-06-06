extends BattleAction
class_name DamageBattleAction

#########
## ENUMS
#########

enum TYPE {
	MELEE,
	RANGED
}

###########
## EXPORTS
###########

@export var type: TYPE = TYPE.MELEE
@export var damage: int = 5
