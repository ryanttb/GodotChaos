class_name PlayerBody
extends CharacterBase

signal moved(direction: Vector2)

var power: int = 10

func _physics_process(_delta: float) -> void:
	process_input()

func process_input() -> void:
	var direction := Vector2.ZERO
	
	# Check for just pressed inputs
	if Input.is_action_just_pressed("move_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_just_pressed("move_left"):
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("move_down"):
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("move_up"):
		direction = Vector2.UP
		
	if direction != Vector2.ZERO:
		move(direction)
	
	if Input.is_action_just_pressed("attack_right"):
		attack(Vector2.RIGHT)
	elif Input.is_action_just_pressed("attack_left"):
		attack(Vector2.LEFT)
	elif Input.is_action_just_pressed("attack_down"):
		attack(Vector2.DOWN)
	elif Input.is_action_just_pressed("attack_up"):
		attack(Vector2.UP)

func move(direction: Vector2) -> void:
	var result = query_ray(global_position, direction)

	if result and result.collider.is_in_group("Enemies"):
		# if ray hit an enemy, attack
		attack(direction)
	elif result and result.collider.is_in_group("Walls"):
		# if ray hit a wall, don't move
		return
	else:
		position += direction * GRID_SIZE
		moved.emit(direction)

func take_damage(amount: int) -> void:
	print("Player take_damage: ", amount)
	GameState.player_health -= amount
	if GameState.player_health <= 0:
		get_tree().reload_current_scene()
	else:
		$AnimationPlayer.play("take_damage")

func attack(direction: Vector2) -> void:
	print("Player attack: ", direction)
	var result = query_ray(global_position, direction)
	if result:
		print("Player attack hit: ", result)
		var collider = result.collider
		if collider.is_in_group("Enemies"):
			(collider as EnemyBody).take_damage(power)
