extends Area2D


func _on_animation_finished(anim_name: StringName) -> void:
	queue_free()
