extends Node

#############
## VARIABLES
#############

var turn_manager := TurnManager.new()
var async_turn_pool := AsyncTurnPool.new()
var elizabeth_stats: PlayerClassStats = load("res://class_stats/elizabeth_class_stats.tres")
var inventory: Inventory = load("res://items/inventory.tres")
var random_encounters: Array[ClassStats] = []
var encounter_class: ClassStats
var player: OverworldPlayer
