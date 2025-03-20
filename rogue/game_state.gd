extends Node

var player_health: int = 100
var player_max_health: int = 100

var player_coins: int = 0

var level: int = 1
var level_seed: int = 37

func reset() -> void:
	player_health = player_max_health
	player_coins = 0
	level = 1
	level_seed = 52319
