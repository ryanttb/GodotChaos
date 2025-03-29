extends CharacterBody2D

@export var speed: float = 128.0
@export var fire_rate: float = 0.1
@export var rotation_speed: float = 10.0  # How fast the crab rotates

@onready var projectile_pool: ObjectPool = $ProjectilePool

var time_since_last_shot: float = 0.0
var target_rotation: float = 0.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		velocity = direction * speed
		target_rotation = direction.angle()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * delta)
	
	# Smoothly rotate towards target rotation
	$Sprite.rotation = move_toward($Sprite.rotation, target_rotation, rotation_speed * delta)

	move_and_slide()

func _process(delta: float) -> void:
	time_since_last_shot += delta
	var fire_direction := Input.get_vector("fire_left", "fire_right", "fire_up", "fire_down")
	if fire_direction != Vector2.ZERO:
		_try_fire_projectile(fire_direction)

func _try_fire_projectile(dir: Vector2) -> void:
	if time_since_last_shot >= fire_rate:
		var projectile = projectile_pool.get_object()
		projectile.reset()
		projectile.global_position = $Sprite.global_position
		projectile.direction = dir
		time_since_last_shot = 0.0
