class_name PlayerBody
extends CharacterBase

@onready var walk_sfx = preload("res://sfx/Walk.wav")
@onready var hit_sfx = preload("res://sfx/Hit.wav")
@onready var heal_sfx = preload("res://sfx/Heart.wav")
@onready var key_sfx = preload("res://sfx/Key.wav")
@onready var coin_sfx = preload("res://sfx/Coin.wav")
@onready var death_sfx = preload("res://sfx/Death.wav")

signal moved(direction: Vector2)
signal health_changed(health: int)
signal coins_changed(coins: int)
signal keys_changed(keys: int)

var power: int = 10

@onready var is_dead: bool = GameState.player_health <= 0

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
		$SFX.stream = walk_sfx
		$SFX.play()
		moved.emit(direction)

func take_damage(amount: int) -> void:
	print("Player take_damage: ", amount)
	GameState.player_health -= amount
	if GameState.player_health <= 0:
		is_dead = true
		$SFX.stream = death_sfx
		$SFX.play()
	else:
		$AnimationPlayer.play("take_damage")
		$SFX.stream = hit_sfx
		$SFX.play()
		health_changed.emit(GameState.player_health)

func heal(amount: int) -> void:
	GameState.player_health = min(GameState.player_health + amount, GameState.player_max_health)
	$SFX.stream = heal_sfx
	$SFX.play()
	health_changed.emit(GameState.player_health)

func add_coins(amount: int) -> void:
	GameState.player_coins += amount
	$SFX.stream = coin_sfx
	$SFX.play()
	coins_changed.emit(GameState.player_coins)

func add_key() -> void:
	GameState.player_keys += 1
	$SFX.stream = key_sfx
	$SFX.play()
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


func _on_sfx_finished() -> void:
	if is_dead:
		GameState.reset()
		get_tree().reload_current_scene()
