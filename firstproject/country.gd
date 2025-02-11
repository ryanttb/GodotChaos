extends Node2D

@export var country_name: String = ""
@export var population: int = 0
@export var highest_altitude: float = 1.0
@export var landlocked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(320, 320)
	print(country_name, position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
