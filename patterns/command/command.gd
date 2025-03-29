class_name Command
extends Node

# base class for all Commands

func execute() -> void:
	pass

func undo() -> void:
	pass

# not required in subclasses, but available for convenience
func redo() -> void:
	execute()
