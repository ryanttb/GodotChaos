class_name StateMachine
extends Node

@export var default_state: State

var states: Dictionary = {}
var current_state: State

func _ready():
	print("StateMachine _ready")
	await get_tree().create_timer(0.5).timeout
	
	for child in get_children():
		if child is State:
			states[child.name] = child
			child._initialize()
	
	if default_state:
		change_state(default_state.name)

func _process(delta: float) -> void:
	if current_state:
		current_state._update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_update(delta)

func _on_navigation_finished() -> void:
	if current_state:
		current_state._navigation_complete()

func change_state(state_name: String) -> void:
	print("StateMachine change_state state_name: ", state_name)
	var new_state = states.get(state_name) as State
	
	if new_state == null or new_state == current_state:
		return
	
	if current_state:
		current_state._exit()
	
	current_state = new_state
	current_state._enter()
