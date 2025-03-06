class_name ShotBody
extends CharacterBody3D

@export var speed := 24.0

var target: Node3D

var damage: int

func _ready() -> void:
	var direction = Vector3.ZERO
	if is_instance_valid(target):
		direction = global_position.direction_to(target.global_position)
		look_at(target.global_position)
	else:
		direction = Vector3(0, 0, 1)
	
	velocity = direction * speed
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemies"):
		(body as EnemyBody).take_damage(damage)
		queue_free()
