extends Control

class_name GameOverScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://zenva_mobile.tscn")


func _on_again_button_timer_timeout() -> void:
	$AgainButton.show()
