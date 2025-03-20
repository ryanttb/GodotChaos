class_name EnemyBody
extends CharacterBase

@export var health: int = 100
@export var max_health: int = 100

@export var power: int = 10

@onready var player: PlayerBody = get_tree().get_first_node_in_group("Player")

var move_chance: float = 0.5
var attack_chance: float = 0.5

func _ready() -> void:
	if not is_instance_valid(player):
		print("Enemy ERROR: player not found")
		return

	health = max_health

func move() -> void:
	if randf() < move_chance:
		return

	var can_move: bool = false
	var direction: Vector2 = Vector2.ZERO

	direction = random_direction()
	can_move = not is_wall_in_direction(direction)

	if can_move:
		position += direction * GRID_SIZE

func take_damage(amount: int) -> void:
	print("Enemy take_damage: ", amount)
	health -= amount
	if health <= 0:
		queue_free()
	else:
		$AnimationPlayer.play("take_damage")
		if randf() < attack_chance:
			player.take_damage(power)
