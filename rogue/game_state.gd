extends Node

const PIXELS_PER_BLOCK := 16
const BLOCKS_PER_ROOM := 17

const ROOM_INSIDE_WIDTH := 9
const ROOM_INSIDE_HEIGHT := 9
const ROOM_INSIDE_OFFSET := 4

const EMPTY_ROOM_POSITION: Vector2i = Vector2i(-1, -1)

var player_health: int = 100
var player_max_health: int = 100

var player_coins: int = 0
var player_keys: int = 0
var player_steps: int = 0

var enemies_killed: int = 0

var level: int = 1
var level_seed: int = 56 if OS.is_debug_build() else randi()

func reset() -> void:
	player_health = player_max_health
	player_coins = 0
	player_keys = 0
	player_steps = 0
	enemies_killed = 0
	level = 1
	level_seed = 56 if OS.is_debug_build() else randi()

# keep health, coins, keys
func next_level() -> void:
	level += 1
	level_seed = randi()
