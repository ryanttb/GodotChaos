extends ItemArea

func _on_body_entered(body: Node2D) -> void:
	print("HealthItem _on_body_entered")
	if body.is_in_group("Player"):
		(body as PlayerBody).heal(10)
		queue_free()
