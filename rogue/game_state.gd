extends Node

const PIXELS_PER_BLOCK := 16
const BLOCKS_PER_ROOM := 17

const ROOM_INSIDE_WIDTH := 9
const ROOM_INSIDE_HEIGHT := 9
const ROOM_INSIDE_OFFSET := 4

var player_health: int = 100
var player_max_health: int = 100

var player_coins: int = 0

var level: int = 1
var level_seed: int = 56 if OS.is_debug_build() else randi()

func reset() -> void:
	player_health = player_max_health
	player_coins = 0
	level = 1
	level_seed = 56 if OS.is_debug_build() else randi()
