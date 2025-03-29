class_name BarrelManager
extends Node

signal barrel_fire_changed(burning: bool)

var barrels_burning: bool = false

# even better, do it at the observer instead of the manager
#func _ready() -> void:
#	for child in $"../Barrels".get_children():
#		var barrel = child as Barrel
#		barrel_fire_changed.connect(barrel._on_barrel_manager_barrel_fire_changed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		barrels_burning = not barrels_burning
		barrel_fire_changed.emit(barrels_burning)
