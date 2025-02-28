class_name PlayerBody
extends CharacterBody3D

@export_group("Movement")
@export var max_speed := 6.0
@export var acceleration := 20.0
@export var breaking := 20.0 # how fast we slow down
@export var air_acceleration := 6.0 # acceleration while in the air, slower than ground acceleration
@export var jump_force := 6.0
@export var gravity_modifier := 1.5 # player has slightly different gravity than project
@export var max_run_speed := 10.0

@export_group("Camera")
@export var look_sensitivity := 0.005
@export var controller_sensitivity := 10

var camera_look_input := Vector2.ZERO

var is_playing := true
var is_running := false

@onready var camera: Camera3D = $Camera3D
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Mouse
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("tap"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	is_playing = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	# Movement
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Running
	is_running = Input.is_action_pressed("run")
	
	var target_speed = max_speed
	if is_running:
		target_speed = max_run_speed
		var run_dot = -direction.dot(transform.basis.z)
		direction *= clampf(run_dot, 0, 1)
	
	# Smoothing
	var current_smoothing = acceleration
	if not is_on_floor():
		current_smoothing = air_acceleration
	elif not direction:
		current_smoothing = breaking
	
	var target_velocity = direction * target_speed
	
	# Finally, set direction
	velocity.x = lerp(velocity.x, target_velocity.x, current_smoothing * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, current_smoothing * delta)
	
	move_and_slide()
	
	# Look and turn
	if is_playing:
		# Controller overrides
		var joy_vector = Input.get_vector("turn_left", "turn_right", "look_up", "look_down")
		if joy_vector:
			camera_look_input = joy_vector * controller_sensitivity
		
		rotate_y(-camera_look_input.x * look_sensitivity)
		
		camera.rotate_x(-camera_look_input.y * look_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -1.5, 1.5)
		
	camera_look_input = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if is_playing and event is InputEventMouseMotion:
		camera_look_input = event.relative	
		print("look: ", camera_look_input)
