extends Node

var timer := 0.0

var time_left := 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += 1.0 * delta
	
	time_left -= delta
	print(time_left)
	
	if time_left <= 0.0:
		set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	$Node3D/Snowman.position.z -= 1.0 * delta
	$Node2D/Player.position.x += 100 * delta
