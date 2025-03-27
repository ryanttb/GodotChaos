extends Control

func _ready() -> void:
	$Intro.visible = true
	$Play.visible = false

func _on_play_pressed() -> void:
	$Intro.visible = false
	$Play.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	GameState.reset()
	if %Seed.value != 0:
		GameState.level_seed = %Seed.value
	get_tree().change_scene_to_file("res://rogue_main.tscn")

func _on_back_pressed() -> void:
	$Play.visible = false
	$Intro.visible = true
