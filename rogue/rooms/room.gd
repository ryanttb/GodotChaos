class_name RoomNode
extends Node2D

@export var generation: Generation

@export var EnemyScene: PackedScene
@export var CoinScene: PackedScene
@export var HealthItemScene: PackedScene
@export var KeyScene: PackedScene
@export var ExitDoorScene: PackedScene

var inside_width := 9
var inside_height := 9
var room_position: Vector2i

var used_positions: Array[Vector2i] = []

func spawn_nodes() -> void:
	for i in range(generation.max_enemies_per_room):
		try_spawn_node(EnemyScene, generation.enemy_spawn_rate)
	for i in range(generation.max_coins_per_room):
		try_spawn_node(CoinScene, generation.coin_spawn_rate)
	for i in range(generation.max_health_items_per_room):
		try_spawn_node(HealthItemScene, generation.health_item_spawn_rate)
	for i in range(generation.max_keys_per_room):
		try_spawn_node(KeyScene, generation.key_spawn_rate)
	for i in range(generation.max_exit_doors_per_room):
		try_spawn_node(ExitDoorScene, generation.exit_door_spawn_rate)

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

func try_spawn_node(node_scene: PackedScene, spawn_rate: float) -> void:
	if node_scene == null:
		print("Room try_spawn_node: node_scene is null")
		return

	if randf() < spawn_rate:
		var spawn_position: Vector2i = Vector2i(randi() % inside_width, randi() % inside_height)
		if check_spawn_position(spawn_position):
			var node: Node2D = node_scene.instantiate()
			print("Room try_spawn_node name: ", node.name, " room_position: ", room_position, " spawn_position: ", spawn_position)
			node.position = spawn_position * GameState.PIXELS_PER_BLOCK * GameState.BLOCKS_PER_ROOM
			if node_scene == EnemyScene:
				var enemies_root = get_tree().get_first_node_in_group("EnemiesRoot")
				enemies_root.add_child(node)
			else:
				add_child(node)
