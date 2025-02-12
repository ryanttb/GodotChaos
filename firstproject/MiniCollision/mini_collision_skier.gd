extends RigidBody3D

@export var move_speed := 24.0

func _physics_process(delta: float) -> void:
	var dir = Input.get_axis("ui_left", "ui_right")
	linear_velocity.x += dir * 0.1
	


func _on_body_entered(body: Node) -> void:
	print("skier on_body_entered body: ", body.name)
	if body.is_in_group("trees"):
		get_tree().reload_current_scene()
