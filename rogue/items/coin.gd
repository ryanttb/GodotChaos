extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("Coin _on_body_entered body: ", body.name)
	if body.is_in_group("Player"):
		(body as PlayerBody).add_coins(1)
		(Sfx as SfxNode).play_coin()
		queue_free()
