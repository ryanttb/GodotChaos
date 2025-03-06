class_name HealthBar3D
extends Sprite3D

@onready var bar: HealthBar = $SubViewport/HealthBar

func _ready() -> void:
	texture = $SubViewport.get_texture()

func init(amount: int) -> void:
	bar.init(amount)

func update(amount: int) -> void:
	bar.update(amount)
