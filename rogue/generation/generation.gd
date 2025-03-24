class_name Generation
extends Node

@export_group("Room Generation")
@export var RoomScene: PackedScene
@export var map_width := 7
@export var map_height := 7
@export var rooms_to_generate := 12
@export var min_rooms := 5  # Minimum number of rooms we want to generate

@export_group("Spawn Rates")
@export var enemy_spawn_rate := 0.5
@export var max_enemies_per_room := 2

@export var coin_spawn_rate := 0.5
@export var max_coins_per_room := 3

@export var health_item_spawn_rate := 0.5
@export var max_health_items_per_room := 1

@export var key_spawn_rate := 0.5
@export var max_keys_per_room := 1

@export var exit_door_spawn_rate := 0.5
@export var max_exit_doors_per_room := 1

@onready var player: PlayerBody = get_tree().get_first_node_in_group("Player")

var room_count := 0
var rooms_instantiated: bool = false

var first_room_pos: Vector2i

var map: Array
var room_nodes: Array[Node] = []

func _ready() -> void:
	pass

func clear_map() -> void:
	free_rooms()

	map = []
	room_count = 0
	map.resize(map_width)
	for i in range(map_width):
		var map_col: Array[bool]
		map_col.resize(map_height)
		map_col.fill(false)
		map[i] = map_col

func generate_map(x: int, y: int) -> void:
	# Try to generate until we have enough rooms
	while room_count < min_rooms:
		clear_map()
		generate_room(x, y, rooms_to_generate, Vector2.ZERO, true)

func generate_room(x: int, y: int, remaining_rooms: int, general_direction: Vector2, first_room: bool = false) -> void:
	if room_count >= rooms_to_generate:
		print("Generation generate_room all rooms generated")
		return
	
	if x < 0 or x >= map_width or y < 0 or y >= map_height:
		print("Generation generate_room out of bounds")
		return
	
	if not first_room and remaining_rooms <= 0:
		print("Generation generate_room remaining_rooms <= 0")
		return
	
	if map[x][y]:
		print("Generation generate_room already generated")
		return

	if first_room:
		first_room_pos = Vector2i(x, y)  
	
	map[x][y] = true
	room_count += 1

	# Adjust probabilities to be more likely to generate rooms
	# Even in the general direction, we want a decent chance to generate
	var north: bool = randf() > (0.4 if general_direction == Vector2.UP else 0.6)
	var east: bool = randf() > (0.4 if general_direction == Vector2.RIGHT else 0.6)
	var south: bool = randf() > (0.4 if general_direction == Vector2.DOWN else 0.6)
	var west: bool = randf() > (0.4 if general_direction == Vector2.LEFT else 0.6)

	# If we're not generating enough rooms, force at least one direction
	if room_count < min_rooms:
		var directions = []
		if north: directions.append(Vector2.UP)
		if east: directions.append(Vector2.RIGHT)
		if south: directions.append(Vector2.DOWN)
		if west: directions.append(Vector2.LEFT)
		
		# If no directions were chosen, force one randomly
		if directions.is_empty():
			directions = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
			directions.shuffle()
			var forced_direction = directions[0]
			match forced_direction:
				Vector2.UP: north = true
				Vector2.RIGHT: east = true
				Vector2.DOWN: south = true
				Vector2.LEFT: west = true

	var max_remaining_rooms: int = rooms_to_generate if first_room else remaining_rooms - 1

	if north:
		generate_room(x, y - 1, max_remaining_rooms, Vector2.UP if first_room else general_direction)
	if east:
		generate_room(x + 1, y, max_remaining_rooms, Vector2.RIGHT if first_room else general_direction)
	if south:
		generate_room(x, y + 1, max_remaining_rooms, Vector2.DOWN if first_room else general_direction)
	if west:
		generate_room(x - 1, y, max_remaining_rooms, Vector2.LEFT if first_room else general_direction)

func print_map() -> void:
	var preview_map: String = ""
	for y in range(map_height):
		for x in range(map_width):
			preview_map += "|o|" if map[x][y] else "| |"
		preview_map += "\n"
	print(preview_map)

func instantiate_rooms() -> void:
	if rooms_instantiated:
		return

	for y in range(map_height):
		for x in range(map_width):
			if map[x][y]:
				var room_pos: Vector2i = Vector2i(x, y)
				var room_node: RoomNode = RoomScene.instantiate()
				room_node.position = room_pos * GameState.PIXELS_PER_BLOCK * GameState.BLOCKS_PER_ROOM

				if y > 0 and map[x][y - 1]:
					room_node.open_door(Vector2.UP)
				if x < map_width - 1 and map[x + 1][y]:
					room_node.open_door(Vector2.RIGHT)
				if y < map_height - 1 and map[x][y + 1]:
					room_node.open_door(Vector2.DOWN)
				if x > 0 and map[x - 1][y]:
					room_node.open_door(Vector2.LEFT)
				
				room_node.generation = self
				room_node.room_position = room_pos

				room_nodes.append(room_node)

				var room_root = get_tree().get_first_node_in_group("RoomRoot")
				if is_instance_valid(room_root):
					room_root.add_child(room_node)

				room_node.spawn_nodes()

	rooms_instantiated = true

func free_rooms() -> void:
	for room_node in room_nodes:
		room_node.queue_free()
	room_nodes.clear()
	rooms_instantiated = false
	
