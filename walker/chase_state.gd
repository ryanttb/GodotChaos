class_name ChaseState
extends State

@export var stop_range := 1.0 # meters from player where bug stops
@export var lose_interest_range := 10.0 # stop chasing if player gets this far away

var path_update_rate := 0.1 # seconds between AI path updates (in case player moves)
var last_path_update_time: float # time of last update

func _enter():
	super._enter()
	controller.is_running = true
	controller.looking_at_player = true

func _exit():
	super._exit()
	controller.is_running = false
	controller.looking_at_player = false

func _update(_delta: float):
	var current_time = Time.get_unix_time_from_system()
	
	if current_time - last_path_update_time > path_update_rate:
		last_path_update_time = current_time
		controller.move_to_position(controller.player.position)
	
	if controller.player_distance < stop_range:
		state_machine.change_state("Flee")
	
	if controller.player_distance > lose_interest_range:
		state_machine.change_state("Wander")
