extends Area2D

class_name PrincessNode

const SPEED := 400.0

const BOUNDS_MIN := Vector2(10, 10)
const BOUNDS_MAX := Vector2(544 - 10, 960 - 10)

const BOUNDS := Rect2(Vector2(10, 10), Vector2(544 - 20, 960 - 20))

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		position.x = clampf(position.x + direction.x * SPEED * delta, BOUNDS_MIN.x, BOUNDS_MAX.x)
		position.y = clampf(position.y + direction.y * SPEED * delta, BOUNDS_MIN.y, BOUNDS_MAX.y)
	
func _input(event: InputEvent) -> void:
	if is_position_event(event):
		position.x = clampf(event.position.x, BOUNDS_MIN.x, BOUNDS_MAX.x)
		position.y = clampf(event.position.y, BOUNDS_MIN.y, BOUNDS_MAX.y)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		var main: TownAttackMain = get_tree().get_first_node_in_group("Main")
		main.game_over()

func is_position_event(event: InputEvent) -> bool:
	return event is InputEventMouse or event is InputEventScreenDrag or event is InputEventScreenTouch

func print_input_event(event: InputEvent) -> void:
	print("Princess print_input_event position: ", event.position)
	print("  ", event.as_text())
	print("  is_action tap: ", event.is_action("tap"))
	print("  is InputEventMouseButton: ", event is InputEventMouseButton)
	print("  is InputEventScreenDrag: ", event is InputEventScreenDrag)
	print("  is InputEventScreenTouch: ", event is InputEventScreenTouch)
