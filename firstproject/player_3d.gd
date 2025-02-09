extends CharacterBody3D

@export var speed: int = 14
@export var fall_acceleration: int = 75
@export var jump_impulse: int = 20
@export var bounce_impulse: int = 16

signal hit

var target_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	# get the input direction and handle the movement/deceleration
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y)
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
		# set the basis to align orientation to face a specific vector
		$Pivot.basis = Basis.looking_at(direction)
		# or, if you want to align orientation to face a specific point in space
		#$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1

	# XZ-plane for ground velocity.
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Add the gravity for vertical velocity.
	if not is_on_floor():
		target_velocity.y -= (fall_acceleration * delta)

	# handle jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# iterate through all collisions
	for index in range(get_slide_collision_count()):
		var collision: KinematicCollision3D = get_slide_collision(index)
		
		# ignore ground collision (no collider/mob)
		if collision.get_collider() == null:
			continue
		
		# if mob
		var collider: Node3D = collision.get_collider()
		if collider.is_in_group("mob"):
			var mob: MobBody3D = collider
			
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				break;
			

	# move player
	velocity = target_velocity
	move_and_slide()

	# make player "arc" when jumping?
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse


func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()

func die() -> void:
	hit.emit()
	queue_free()
