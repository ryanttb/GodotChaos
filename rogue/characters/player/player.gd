class_name PlayerBody
extends CharacterBase

@onready var walk_sfx = preload("res://sfx/Walk.wav")
@onready var hit_sfx = preload("res://sfx/Hit.wav")

signal moved(direction: Vector2)
signal health_changed(health: int)
signal coins_changed(coins: int)
signal keys_changed(keys: int)

signal died

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

	if result:
		print("Player move: result: ", result)

	if result and result.collider.is_in_group("Enemies"):
		# if ray hit an enemy, attack
		attack(direction)
	elif result and result.collider.is_in_group("Walls"):
		# if ray hit a wall, don't move
		return
	else:
		position += direction * GameState.PIXELS_PER_BLOCK
		GameState.player_steps += 1
		# this sfx is local to the player and does not use SfxNode
		$SFX.stream = walk_sfx
		$SFX.play()
		moved.emit(direction)

func take_damage(amount: int) -> void:
	print("Player take_damage: ", amount)
	GameState.player_health -= amount
	health_changed.emit(GameState.player_health)
	
	if GameState.player_health <= 0:
		died.emit()
	else:
		$AnimationPlayer.play("take_damage")
		# this sfx is local to the player and does not use SfxNode
		$SFX.stream = hit_sfx
		$SFX.play()

func heal(amount: int) -> void:
	GameState.player_health = min(GameState.player_health + amount, GameState.player_max_health)
	(Sfx as SfxNode).play_heart()
	health_changed.emit(GameState.player_health)

func add_coins(amount: int) -> void:
	GameState.player_coins += amount
	coins_changed.emit(GameState.player_coins)

func add_key() -> void:
	GameState.player_keys += 1
	(Sfx as SfxNode).play_key()
	keys_changed.emit(GameState.player_keys)

func use_key() -> void:
	if GameState.player_keys > 0:
		GameState.player_keys -= 1
		keys_changed.emit(GameState.player_keys)
	else:
		print("Player use_key: no keys")

func attack(direction: Vector2) -> void:
	print("Player attack: ", direction)
	var result = query_ray(global_position, direction)
	if result:
		print("Player attack hit: ", result)
		var collider = result.collider
		if collider.is_in_group("Enemies"):
			(collider as EnemyBody).take_damage(power)
