extends Node

@onready var player: PlayerBody = get_tree().get_first_node_in_group("Player")

@onready var enemies: Array[Node] = get_tree().get_nodes_in_group("Enemies")
@onready var items: Array[Node] = get_tree().get_nodes_in_group("Items")

@onready var generation: Generation = $Generation

const PLAYER_START_POSITION := Vector2i(3, 3)

func _ready() -> void:
	if not is_instance_valid(player):
		print("RogueMain ERROR: player not found")
		return
	
	GameState.reset()
	%HealthLabel.text = "Health: " + str(GameState.player_health)
	%CoinsLabel.text = "Coins: " + str(GameState.player_coins)

	player.moved.connect(_on_player_moved)

	print("RogueMain _ready generating map seed: ", GameState.level_seed)

	generation.clear_map()
	
	seed(GameState.level_seed)
	generation.generate_map(PLAYER_START_POSITION.x, PLAYER_START_POSITION.y)
	generation.print_map()
	generation.instantiate_rooms()

	enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		print("Enemy: ", enemy, " position: ", enemy.position)

	if is_instance_valid(player):
		player.global_position = (generation.first_room_pos * GameState.BLOCKS_PER_ROOM + Vector2i(GameState.ROOM_INSIDE_OFFSET + 2, GameState.ROOM_INSIDE_OFFSET + 2)) * GameState.PIXELS_PER_BLOCK
	
func _on_player_moved(_direction: Vector2) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			(enemy as EnemyBody).move()

func _on_player_health_changed(health: int) -> void:
	print("RogueMain _on_player_health_changed: ", health)
	%HealthLabel.text = "Health: " + str(health)

	var current_health: float = 100.0 * health / GameState.player_max_health

	var hearts: Array[Node] = %HealthBar.get_children()
	for i in range(hearts.size()):
		var heart = hearts[i] as Sprite2D
		heart.frame = 2 if current_health >= 20 else 1 if current_health >= 10 else 0
		current_health -= 20

func _on_player_coins_changed(coins: int) -> void:
	%CoinsLabel.text = "Coins: " + str(coins)
