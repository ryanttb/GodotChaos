class_name Barrel
extends Sprite2D

@onready var barrel_manager: BarrelManager = get_tree().get_first_node_in_group("BarrelManager")

func _ready() -> void:
	barrel_manager.barrel_fire_changed.connect(set_burning)

func set_burning(burning: bool) -> void:
	if burning:
		region_rect.position.x = 221.0 + 17
	else:
		region_rect.position.x = 221.0
