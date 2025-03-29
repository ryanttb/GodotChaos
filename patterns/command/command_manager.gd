class_name CommandManager
extends Node

# manager for all commands

var undo_stack: Array[Command] = []
var redo_stack: Array[Command] = []

func execute_command(command: Command) -> void:
	command.execute()
	undo_stack.append(command)
	redo_stack.clear()

func undo_command() -> void:
	if undo_stack.size() > 0:
		var command = undo_stack.pop_back()
		command.undo()
		redo_stack.append(command)

func redo_command() -> void:
	if redo_stack.size() > 0:
		var command = redo_stack.pop_back()
		command.execute()
		undo_stack.append(command)
