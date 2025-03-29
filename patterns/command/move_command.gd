class_name MoveCommand
extends Command

var mover: SpriteMover
var sprite: Sprite2D
var move_direction: Vector2

static func create(sm: SpriteMover, s: Sprite2D, dir: Vector2) -> MoveCommand:
	var command = MoveCommand.new()
	command.mover = sm
	command.sprite = s
	command.move_direction = dir
	return command

func execute() -> void:
	mover.move(sprite, move_direction)

func undo() -> void:
	mover.move(sprite, -move_direction)
