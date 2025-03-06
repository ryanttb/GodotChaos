class_name EnemyBody
extends CharacterBody3D

signal enemy_defeated(payout: int)

@export var max_health := 25
@export var speed := 2.0
@export var damage := 20
@export var payout := 50

@onready var path_follower: PathFollow3D = get_parent() as PathFollow3D

var health := max_health
var is_alive := true

func _ready() -> void:
	health = max_health
	var health_bar: ProgressBar = get_node("./MeshInstance3D/HealthBar")
	if is_instance_valid(health_bar):
		health_bar.max_value = max_health
		health_bar.value = health
	
func _process(_delta: float) -> void:
	var health_bar: ProgressBar = get_node("./MeshInstance3D/HealthBar")
	if is_instance_valid(health_bar):
		health_bar.value = health
		
		# Get the camera from the scene
		var camera = get_viewport().get_camera_3d()
		if camera:
			# Convert 3D position to 2D screen coordinates
			var screen_pos = camera.unproject_position(global_position + Vector3(0, 2, 0))  # Offset up by 2 units
			health_bar.global_position = screen_pos

func _physics_process(delta: float) -> void:
	path_follower.set_progress(path_follower.get_progress() + speed * delta)
	
	if path_follower.get_progress_ratio() >= 0.99:
		GlobalState.health -= damage
		kill()

# Override this one
func _on_damage_taken() -> void:
	pass
	
func take_damage(amount: int) -> void:
	health -= amount
	_on_damage_taken()
	
	if health <= 0 and is_alive:
		enemy_defeated.emit(payout)
		print("Enemy take_damage money: ", GlobalState.money)
		kill()

func kill() -> void:
	print("EnemyBody kill")
	is_alive = false
	GlobalState.enemies_alive -= 1
	path_follower.queue_free()
