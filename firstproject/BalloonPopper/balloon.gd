extends Area3D

@export var clicks_to_pop := 3
@export var size_increase := 0.2
@export var score_to_give := 1

var current_clicks := 0

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		scale *= (1.0 + size_increase)
		current_clicks += 1
		
		if current_clicks >= clicks_to_pop:
			var main: BalloonPopperMain = get_node("/root/BalloonPopper")
			main.increase_score(score_to_give)
			queue_free()
