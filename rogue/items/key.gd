extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("Key _on_body_entered body: ", body.name)
	if body.is_in_group("Player"):
		(body as PlayerBody).add_key()
		queue_free()
