extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_commands_pressed() -> void:
	get_tree().change_scene_to_file("res://command/command_main.tscn")


func _on_object_pool_pressed() -> void:
	get_tree().change_scene_to_file("res://object_pool/object_pool_main.tscn")


func _on_observer_pressed() -> void:
	get_tree().change_scene_to_file("res://observer/observer.tscn")


func _on_single_resp_pressed() -> void:
	get_tree().change_scene_to_file("res://single_responsibility/single_responsibility.tscn")
