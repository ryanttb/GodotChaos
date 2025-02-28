extends InteractableObject

@onready var light_bulb = $LightBulb

signal pedestal_enabled

func _interact() -> void:
	#light_bulb.visible = !light_bulb.visible
	light_bulb.show()
	can_interact = false
	pedestal_enabled.emit()
