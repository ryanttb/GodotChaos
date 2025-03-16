class_name WanderState
extends State

@export var max_wander_range := 6.0 # don't wander too far from home_position

# time at previous final position before picking a new one
@export var min_wait_time := 0.2 
@export var max_wait_time := 2.0

@export var chase_range := 4.0 # if the player is within this range, the enemy will chase the player

var home_position: Vector3

func _enter() -> void:
	#print("WanderState enter")
	super._enter()
	
	controller.is_stopped = false
	home_position = controller.position
	new_wander_position()

func _navigation_complete():
	var wait_time = randf_range(min_wait_time, max_wait_time)
	await get_tree().create_timer(wait_time).timeout
	
	# state could change while we're waiting for timeout
	if active:
		new_wander_position()
	
func new_wander_position():
	#print("WanderState new_wander_position")
	var pos = home_position + random_offset() * randf_range(0, max_wander_range)
	controller.move_to_position(pos)

func _update(_delta: float) -> void:
	if controller.player_distance < chase_range:
		state_machine.change_state("Chase")
