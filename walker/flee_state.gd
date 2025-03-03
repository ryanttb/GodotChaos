class_name FleeState
extends State

@export var flee_distance := 6.0 # how far to run away

func _enter() -> void:
	super._enter()
	controller.is_running = true
	update_flee_position()

func _exit() -> void:
	super._exit()
	controller.is_running = false

func _navigation_complete() -> void:
	state_machine.change_state("Wander")

func update_flee_position() -> void:
	# Get direction from player to enemy (opposite of toward player)
	var flee_direction = controller.player.position.direction_to(controller.position).normalized()
	
	# Calculate position to run to
	var flee_position = controller.player.position + (flee_direction * flee_distance)
	
	# Move there!
	controller.move_to_position(flee_position)
