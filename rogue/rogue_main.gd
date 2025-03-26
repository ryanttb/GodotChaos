extends Node

@onready var player: PlayerBody = get_tree().get_first_node_in_group("Player")

@onready var enemies: Array[Node] = get_tree().get_nodes_in_group("Enemies")
@onready var items: Array[Node] = get_tree().get_nodes_in_group("Items")

@onready var generation: Generation = $Generation

@onready var MiniMapCellScene: PackedScene = preload("res://rooms/mini_map_cell.tscn")

const PLAYER_START_ROOM_POSITION := Vector2i(3, 3)

func _ready() -> void:
	if not is_instance_valid(player):
		print("RogueMain ERROR: player not found")
		return
	
	if GameState.level == 1:
		GameState.reset()

	_on_player_health_changed(GameState.player_health)
	_on_player_coins_changed(GameState.player_coins)
	_on_player_keys_changed(GameState.player_keys)

	player.moved.connect(_on_player_moved)

	print("RogueMain _ready generating map seed: ", GameState.level_seed)

	generation.clear_map()
	
	seed(GameState.level_seed)
	generation.generate_map(PLAYER_START_ROOM_POSITION.x, PLAYER_START_ROOM_POSITION.y)
	generation.print_map()
	generation.instantiate_rooms()
	generation.spawn_key_and_exit_door()
	generate_mini_map()
	enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		print("Enemy: ", enemy, " position: ", enemy.position)
	
	if is_instance_valid(player):
		player.global_position = (generation.first_room_pos * GameState.BLOCKS_PER_ROOM + Vector2i(GameState.ROOM_INSIDE_OFFSET + 3, GameState.ROOM_INSIDE_OFFSET + 3)) * GameState.PIXELS_PER_BLOCK
	
	update_mini_map()
	
func _on_player_moved(_direction: Vector2) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			(enemy as EnemyBody).move()

	update_mini_map()

func _on_player_health_changed(health: int) -> void:
	print("RogueMain _on_player_health_changed: ", health)

	var current_health: float = 100.0 * health / GameState.player_max_health

	var hearts: Array[Node] = %HealthBar.get_children()
	for i in range(hearts.size()):
		var heart = hearts[i] as Sprite2D
		heart.frame = 2 if current_health >= 20 else 1 if current_health >= 10 else 0
		current_health -= 20

func _on_player_coins_changed(coins: int) -> void:
	%CoinsLabel.text = " x " + str(coins)

func generate_mini_map() -> void:
	for child in $HUD/MiniMap/MiniMapGrid.get_children():
		child.queue_free()

	$HUD/MiniMap/MiniMapGrid.columns = generation.map_width

	for i in range(generation.map_height):
		for j in range(generation.map_width):
			var cell: MiniMapCell = MiniMapCellScene.instantiate() as MiniMapCell
			cell.cell_position = Vector2i(j, i)
			cell.set_is_room(generation.map[j][i])
			$HUD/MiniMap/MiniMapGrid.add_child(cell)
	
func update_mini_map() -> void:
	var current_room_position: Vector2i = generation.get_room_position(player.global_position)

	for child in $HUD/MiniMap/MiniMapGrid.get_children():
		var cell: MiniMapCell = child as MiniMapCell
		cell.set_is_room_current(cell.cell_position == current_room_position)
	
	%LevelLabel.text = "Level " + str(GameState.level)
		

func _on_player_keys_changed(keys: int) -> void:
	if keys > 0:
		%KeySprite.modulate = Color.WHITE
	else:
		%KeySprite.modulate = "ffffff40"
