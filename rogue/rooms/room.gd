class_name RoomNode
extends Node2D

@export var generation: Generation

@export var EnemyScene: PackedScene
@export var CoinScene: PackedScene
@export var HealthItemScene: PackedScene
@export var KeyScene: PackedScene
@export var ExitDoorScene: PackedScene

var room_position: Vector2i

var used_positions: Array[Vector2i] = []

var is_key_room: bool = false
var is_exit_door_room: bool = false

func spawn_nodes() -> void:
	for i in range(generation.max_enemies_per_room):
		try_spawn_node(EnemyScene, "EnemiesRoot", generation.enemy_spawn_rate)
	for i in range(generation.max_coins_per_room):
		try_spawn_node(CoinScene, "ItemsRoot", generation.coin_spawn_rate)
	for i in range(generation.max_health_items_per_room):
		try_spawn_node(HealthItemScene, "ItemsRoot", generation.health_item_spawn_rate)
	
func spawn_key() -> void:
	is_key_room = true
	try_spawn_node(KeyScene, "ItemsRoot", generation.key_spawn_rate)

func spawn_exit_door() -> void:
	is_exit_door_room = true
	try_spawn_node(ExitDoorScene, "ExitDoorsRoot", generation.exit_door_spawn_rate)

func open_door(direction: Vector2) -> void:
	if direction == Vector2.UP:
		$NorthDoor.visible = true
		$NorthWall.queue_free()
	elif direction == Vector2.DOWN:
		$SouthDoor.visible = true
		$SouthWall.queue_free()
	elif direction == Vector2.LEFT:
		$WestDoor.visible = true
		$WestWall.queue_free()
	elif direction == Vector2.RIGHT:
		$EastDoor.visible = true
		$EastWall.queue_free()

func check_spawn_position(pos: Vector2i) -> bool:
	if used_positions.has(pos):
		return false
	used_positions.append(pos)
	return true

func try_spawn_node(node_scene: PackedScene, node_root_group: String, spawn_rate: float) -> void:
	if node_scene == null:
		print("Room try_spawn_node: node_scene is null")
		return

	if randf() < spawn_rate:
		var spawn_position: Vector2i = Vector2i(randi() % GameState.ROOM_INSIDE_WIDTH, randi() % GameState.ROOM_INSIDE_HEIGHT)
		if check_spawn_position(spawn_position):
			var node: Node2D = node_scene.instantiate()
			print("Room try_spawn_node name: ", node.name, " room_position: ", room_position, " spawn_position: ", spawn_position)
			node.global_position = (room_position * GameState.BLOCKS_PER_ROOM + Vector2i(GameState.ROOM_INSIDE_OFFSET + spawn_position.x, GameState.ROOM_INSIDE_OFFSET + spawn_position.y)) * GameState.PIXELS_PER_BLOCK
			var node_root = get_tree().get_first_node_in_group(node_root_group)
			if is_instance_valid(node_root):
				node_root.add_child(node)
			else:
				print("Room try_spawn_node: node_root is not valid")
