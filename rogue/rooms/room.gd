class_name RoomNode
extends Node2D

@export var generation: Generation

var inside_width := 9
var inside_height := 9

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
