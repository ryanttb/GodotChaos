# Base class for each state, e.g., wander/chase/flee
class_name State
extends Node

var active: bool
var state_machine: StateMachine

# NodePath can be assigned in Inspector and will set the controller var to the actual object
var controller: BugsAiController
@export_node_path("BugsAiController") var controller_path: NodePath

# Node structure is that parent Node is the StateMachine
# and the children Nodes are each State
func _initialize() -> void:
	print("State _initialize")
	state_machine = get_parent()
	controller = get_node(controller_path)

# Called when machine switches to this state.
# Can only have one state active at a time.
func _enter() -> void:
	active = true

func _exit() -> void:
	active = false

# State-specific update logic, separate from the general game loop's process functions
func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

func _navigation_complete() -> void:
	pass

# Returns a normalized offset
func random_offset() -> Vector3:
	var offset := Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
	return offset.normalized()
