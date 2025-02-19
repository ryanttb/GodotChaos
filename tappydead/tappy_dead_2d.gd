extends Node2D

@export var Cresset : PackedScene
@export var Skull : PackedScene
@export var SkellySit : PackedScene

var dynamic_object_speed := 512
var impulse_force := 400

var spawn_obstacle_x := 1024.0
var spawn_cresset_y := 106.0
var spawn_skilly_sit_y := 399.0

var last_obstacle_spawn_position := 0

func _process(delta: float) -> void:
	if $BackgroundWrapper.position.x <= -800:
		$BackgroundWrapper.position.x = 0
		$TilesWrapper.position.x = 0
		
	for o: Node2D in get_tree().get_nodes_in_group("DynamicObjects"):
		o.position.x -= dynamic_object_speed * delta

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("tap"):
		$RigidReaper.apply_central_impulse(Vector2.UP * impulse_force)
		$RigidReaper.apply_torque_impulse(impulse_force)

func _on_obstacle_spawn_timer_timeout() -> void:
	var random := randi() % 2
	var obstacle_instance: Area2D
	
	if random == 0:
		obstacle_instance = Cresset.instantiate()
		$Obstacles.add_child(obstacle_instance)
		obstacle_instance.position.x = spawn_obstacle_x
		obstacle_instance.position.y = spawn_cresset_y
		last_obstacle_spawn_position = 0
	else:
		obstacle_instance = SkellySit.instantiate()
		$Obstacles.add_child(obstacle_instance)
		obstacle_instance.position.x = spawn_obstacle_x
		obstacle_instance.position.y = spawn_skilly_sit_y
		last_obstacle_spawn_position = 2
	
	var scene := get_tree().current_scene as TappyDeadScene
	obstacle_instance.body_entered.connect(scene._on_obstacle_collided.bind(obstacle_instance))

func _on_skull_spawn_timer_timeout() -> void:
	var random := randi() % 3
	if not random == last_obstacle_spawn_position:
		var skull_instance: Area2D = Skull.instantiate()
		$Coins.add_child(skull_instance)
		skull_instance.position.x = spawn_obstacle_x
		skull_instance.position.y = 96 + random * 128
		
		var scene := get_tree().current_scene as TappyDeadScene
		skull_instance.body_entered.connect(scene._on_coin_collided.bind(skull_instance))
