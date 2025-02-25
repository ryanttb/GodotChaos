extends AnimatedSprite2D

class_name ShikiNode

const SHIKI_SIZE := Vector2(44, 112)
const SHIKI_RECT := Rect2(Vector2.ZERO, SHIKI_SIZE)

var tap_bounds := Rect2(0, 64, 1440, 640)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tap") and is_position_event(event):
		if tap_bounds.has_point(event.position):
			if event.position.x > position.x:
				flip_h = true
			else:
				flip_h = false
				
			position = event.position - Vector2(SHIKI_SIZE.x/4.2, SHIKI_SIZE.y/2.2)

func is_position_event(event: InputEvent) -> bool:
	return event is InputEventMouse or event is InputEventScreenDrag or event is InputEventScreenTouch

func set_tap_bounds(new_tap_bounds: Rect2) -> void:
	tap_bounds = new_tap_bounds
