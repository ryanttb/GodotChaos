extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and GameState.player_keys > 0:
		(body as PlayerBody).use_key()
		GameState.next_level()
		get_tree().call_deferred("reload_current_scene")
