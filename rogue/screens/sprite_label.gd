class_name SpriteLabel
extends Label

@export var sprite: Vector2i = Vector2i(1, 0)

func _ready() -> void:
	$Sprite2D.region_rect = Rect2(1 + sprite.x * 17, 1 + sprite.y * 17, 16, 16)
