class_name InteractableObject
extends PhysicsBody3D

@export var interact_prompt := ""
@export var can_interact := true

func _interact() -> void:
	pass # Override this
