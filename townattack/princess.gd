extends Area2D

class_name PrincessNode

const BOUNDS_MIN := Vector2(10, 10)
const BOUNDS_MAX := Vector2(544 - 10, 960 - 10)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("tap") and is_position_event(event):
		position.x = clampf(event.position.x, BOUNDS_MIN.x, BOUNDS_MAX.x)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		var main: TownAttackMain = get_tree().get_first_node_in_group("Main")
		main.game_over()

func is_position_event(event: InputEvent) -> bool:
	return event is InputEventMouseButton or event is InputEventScreenDrag or event is InputEventScreenTouch

func print_input_event(event: InputEvent) -> void:
	print("Princess print_input_event position: ", event.position)
	print("  ", event.as_text())
	print("  is_action tap: ", event.is_action("tap"))
	print("  is InputEventMouseButton: ", event is InputEventMouseButton)
	print("  is InputEventScreenDrag: ", event is InputEventScreenDrag)
	print("  is InputEventScreenTouch: ", event is InputEventScreenTouch)
