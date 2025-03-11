class_name PlayerBody
extends CharacterBody2D

signal damage_taken(amount: float)

const BOUNDS_MIN: Vector2 = Vector2(0, 0)
const BOUNDS_MAX: Vector2 = Vector2(576, 320)

@export var speed := 96
@export var bullet_speed := 128

var last_direction := Vector2.DOWN

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	velocity = direction * speed
	
	if not is_zero(direction):
		last_direction = direction.normalized()
	
	if Input.is_action_just_pressed("shoot"):
		shoot(last_direction)
	
	move_and_slide()
	
	update_sprite()

func update_sprite() -> void:
	if velocity != Vector2.ZERO:
		if abs(velocity.y) > abs(velocity.x):
			$Sprite.frame = 0 if velocity.y > 0 else 2
		else:
			$Sprite.frame = 1
			$Sprite.flip_h = velocity.x < 0

func shoot(direction: Vector2) -> void:
	var obj: CharacterBody2D = $BulletPool.get_bullet()
	obj.global_position = global_position + direction * 16
	obj.velocity = direction * bullet_speed
	obj.show()

func is_zero(direction: Vector2) -> bool:
	direction.x = 0.0 if abs(direction.x) < 0.1 else direction.x
	direction.y = 0.0 if abs(direction.y) < 0.1 else direction.y
	return direction == Vector2.ZERO

func take_damage(amount: float) -> void:
	damage_taken.emit(amount)
