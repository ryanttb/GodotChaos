extends Node2D

@onready var command_manager: CommandManager = $CommandManager
@onready var mover: SpriteMover = $SpriteMover
@onready var snake: Sprite2D = $Snake
@onready var ghost: Sprite2D = $Ghost

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		command_manager.execute_command(MoveCommand.create(mover, snake, Vector2.RIGHT))
	elif Input.is_action_just_pressed("ui_left"):
		command_manager.execute_command(MoveCommand.create(mover, snake, Vector2.LEFT))
	elif Input.is_action_just_pressed("ui_down"):
		command_manager.execute_command(MoveCommand.create(mover, snake, Vector2.DOWN))
	elif Input.is_action_just_pressed("ui_up"):
		command_manager.execute_command(MoveCommand.create(mover, snake, Vector2.UP))
	elif Input.is_action_just_pressed("ui_scale_up"):
		command_manager.execute_command(ScaleCommand.create(ghost, 2.0))
	elif Input.is_action_just_pressed("ui_scale_down"):
		command_manager.execute_command(ScaleCommand.create(ghost, 0.5))
	elif Input.is_action_just_pressed("ui_undo"):
		command_manager.undo_command()
	elif Input.is_action_just_pressed("ui_redo"):
		command_manager.redo_command()
