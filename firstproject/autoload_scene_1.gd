extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	AutoloadGlobal.goto_scene("res://autoload_scene_2.tscn")


func _on_bug_2d_pressed() -> void:
	AutoloadGlobal.goto_scene("res://crys.tscn")


func _on_mob_3d_pressed() -> void:
	AutoloadGlobal.goto_scene("res://mob_3d.tscn")
