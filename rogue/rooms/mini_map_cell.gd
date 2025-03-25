class_name MiniMapCell
extends Panel

var cell_position: Vector2i

var _is_room: bool = false
var _is_room_visited: bool = false
var _is_room_current: bool = false

func set_is_room(value: bool) -> void:
	_is_room = value
	modulate = Color.WHITE if _is_room else Color.TRANSPARENT

func set_is_room_visited(is_visited: bool) -> void:
	_is_room_visited = is_visited

func set_is_room_current(is_current: bool) -> void:
	if _is_room:
		_is_room_current = is_current
		modulate = Color.RED if _is_room_current else Color.WHITE
	elif is_current:
		print("MiniMapCell set_is_room_current: not a room")
