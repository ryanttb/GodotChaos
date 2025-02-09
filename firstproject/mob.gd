extends CharacterBody3D

class_name MobBody3D

# speeds in m/s
@export var min_speed = 10
@export var max_speed = 18

signal squashed

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

# called from mob_3d scene
func initialize(start_position: Vector3, player_position: Vector3) -> void:
	player_position.y = 0.0
	
	# position and point toward player
	look_at_from_position(start_position, player_position, Vector3.UP)
	
	# rotate a bit so it's not directly at player
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# random speed
	var random_speed = randi_range(min_speed, max_speed)
	
	# calculate velocity length and rotate toward above rotation
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func squash() -> void:
	squashed.emit()
	queue_free()
