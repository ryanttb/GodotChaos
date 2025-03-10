extends EnemyBody

@export var speed := 32
@export var bullet_speed := 128

var last_direction: Vector2

func _ready() -> void:
	print("Serpent _ready")

func _physics_process(_delta: float) -> void:
	if is_alive and is_instance_valid(player):
		last_direction = global_position.direction_to(player.global_position)
		velocity = speed * last_direction
		if last_direction.x > 0:
			$Sprite.flip_h = true
			$SpawnPoint.position.x = 15.0
		else:
			$Sprite.flip_h = false
			$SpawnPoint.position.x = -15.0
			
		# rotation looks silly
		#rotation = rotate_toward(rotation, atan2(last_direction.y, last_direction.x), delta)
		move_and_slide()

func shoot(direction: Vector2) -> void:
	var obj: CharacterBody2D = $EnemyBulletPool.get_bullet()
	obj.global_position = $SpawnPoint.global_position + direction
	obj.velocity = direction * bullet_speed
	obj.show()

func _on_shoot_timer_timeout() -> void:
	shoot(last_direction)
