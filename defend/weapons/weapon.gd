class_name WeaponBody
extends StaticBody3D

@export var bullet_damage := 5

@onready var Bullet: PackedScene = preload("res://weapons/shot.tscn")

var targets: Array[Node3D]
var cur_target: Node3D

var can_shoot := true

var current_aim := 0

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if is_instance_valid(cur_target):
		#rotation.y = rotate_toward(rotation.y, global_position.direction_to(cur_target.global_position).y, 1.0 * _delta)
		look_at(cur_target.global_position)
		if can_shoot:
			shoot()

func _on_mob_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemies"):
		targets.append(body)
		choose_target()

func _on_mob_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group("Enemies"):
		targets.erase(body)
		choose_target()

# Updates cur_target with the closest target in targets or sets it null
func choose_target() -> void:
	cur_target = null
	for target: UFOBody in targets:
		if cur_target == null or target.path_follower.get_progress() > cur_target.path_follower.get_progress():
			print("CannonBody choose_target target: ", target.path_follower.get_progress_ratio())
			cur_target = target

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func shoot() -> void:
	var obj: ShotBody = Bullet.instantiate() as ShotBody
	obj.target = cur_target
	obj.damage = bullet_damage
	$BulletContainer.add_child(obj)
	
	var aims: Array[Node] = %Aims.get_children()
	if aims.size() > current_aim:
		obj.global_position = aims[current_aim].global_position
	
	current_aim = (current_aim + 1) % aims.size()

	can_shoot = false
	$ShootTimer.start()
