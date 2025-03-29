class_name SpriteMover
extends Node

var move_distance: float = 16.0

func move(sprite: Sprite2D, direction: Vector2) -> void:
	sprite.global_position += direction * move_distance
