class_name BugsAiController
extends CharacterBody3D

@export var walk_speed := 1.0
@export var run_speed := 2.5

var is_running := false
var is_stopped := false # pauses AI even if there's still a nav path

var looking_at_player := false

var target_y_rot: float # slowly rotate toward next waypoint or player
var player_distance: float # distance to player node

@onready var agent = $NavigationAgent3D
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")

func _ready():
	print("BugsAiController ready agent: ", agent)

func _process(_delta: float) -> void:
	if player:
		player_distance = position.distance_to(player.position)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# next position in the calculated path to target, avoiding obstacles
	var target_pos = agent.get_next_path_position()
	
	# direction toward next position, set y = 0 to not start floating
	var move_direction = position.direction_to(target_pos)
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	if agent.is_navigation_finished() or is_stopped:
		move_direction = Vector3.ZERO
	
	var current_speed = run_speed if is_running else walk_speed
	
	velocity.x = move_direction.x * current_speed
	velocity.z = move_direction.z * current_speed
	
	move_and_slide()
	
	# atan2 converts a point to an angle
	if looking_at_player:
		var player_dir = player.position - position
		target_y_rot = atan2(player_dir.x, player_dir.z)
	elif velocity.length() > 0:
		# rotate toward current movement direction
		target_y_rot = atan2(velocity.x, velocity.z)
	
	rotation.y = lerp_angle(rotation.y, target_y_rot, 0.1)

# agent path is generated when we assign the target_position
func move_to_position(to_position: Vector3, adjust_position: bool = true):
	print("BugsAiController move_to_position to_position: ", to_position)
	if agent == null:
		return
	
	is_stopped = false
	
	# adjust_position snaps to_position to nav mesh
	# can be expensive, so optional to turn off (player is often already on map)
	# so, leave true if wandering around terrain, false if we know we're chasing player
	if adjust_position:
		var map: RID = get_world_3d().navigation_map
		var adjusted_pos = NavigationServer3D.map_get_closest_point(map, to_position)
		agent.target_position = adjusted_pos
	else:
		agent.target_position = to_position
	
	print("  target_position: ", agent.target_position)
