class_name ItemArea
extends Area2D

# This is a base class for all items.
# It is used to handle the logic for all items.
func _on_body_entered(body: Node2D) -> void:
	print("ItemArea unimplemented _on_body_entered body: ", body.name)
	pass
