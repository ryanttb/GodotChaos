class_name ScaleCommand
extends Command

var sprite: Sprite2D
var scale_factor: float

static func create(s: Sprite2D, sf: float) -> ScaleCommand:
	var command = ScaleCommand.new()
	command.sprite = s
	command.scale_factor = sf
	return command

func execute() -> void:
	sprite.scale *= scale_factor

func undo() -> void:
	sprite.scale /= scale_factor




