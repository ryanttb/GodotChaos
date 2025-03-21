extends Node

@onready var player: PlayerBody = get_tree().get_first_node_in_group("Player")

@onready var enemies: Array[Node] = get_tree().get_nodes_in_group("Enemies")
@onready var items: Array[Node] = get_tree().get_nodes_in_group("Items")

@onready var generation: Generation = $Generation

const PLAYER_START_POSITION := Vector2i(3, 3)
const PLAYER_SCALE := 1.0

func _ready() -> void:
	if not is_instance_valid(player):
		print("RogueMain ERROR: player not found")
		return

	player.moved.connect(_on_player_moved)

	generation.clear_map()
	seed(GameState.level_seed)
	generation.generate_map(PLAYER_START_POSITION.x, PLAYER_START_POSITION.y)
	generation.print_map()
	generation.instantiate_rooms()

	enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		print("Enemy: ", enemy, " position: ", enemy.position)

	if is_instance_valid(player):
		player.position = (generation.first_room_pos * GameState.BLOCKS_PER_ROOM + Vector2i(2, 2)) * GameState.PIXELS_PER_BLOCK * PLAYER_SCALE
	
	var first_enemy: EnemyBody = enemies[0] as EnemyBody
	if is_instance_valid(first_enemy):
		first_enemy.position = (generation.first_room_pos * GameState.BLOCKS_PER_ROOM + Vector2i(6, 6)) * GameState.PIXELS_PER_BLOCK * PLAYER_SCALE	

	var first_item: ItemArea = items[0] as ItemArea
	if is_instance_valid(first_item):
		first_item.position = (generation.first_room_pos * GameState.BLOCKS_PER_ROOM + Vector2i(4, 4)) * GameState.PIXELS_PER_BLOCK * PLAYER_SCALE	
	
func _on_player_moved(_direction: Vector2) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			(enemy as EnemyBody).move()
