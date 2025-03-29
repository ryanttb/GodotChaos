class_name Hammer
extends Area2D

var speed: float = 160.0
var rotation_speed: float = 15.0

# set externally
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	reset()

func _process(delta: float) -> void:
	rotation = wrapf(rotation + rotation_speed * delta, 0.0, TAU)
	position += direction * speed * delta

func _on_destroy_timer_timeout() -> void:
	var pool: ObjectPool = get_parent() as ObjectPool
	pool.return_object(self)


func reset() -> void:
	rotation_speed = randf_range(10.0, 20.0)
	speed = randf_range(128.0, 160.0)
	$DestroyTimer.start.call_deferred()
