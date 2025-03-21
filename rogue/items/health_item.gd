extends ItemArea

func _on_body_entered(body: Node2D) -> void:
	print("HealthItem _on_body_entered")
	if body.is_in_group("Player"):
		GameState.player_health = min(GameState.player_health + 10, GameState.player_max_health)
		queue_free()
