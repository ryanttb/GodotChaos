extends Panel

func _on_back_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")

func _on_visibility_changed() -> void:
	$Buttons/LevelLabel.text = str(GameState.level)
	$Buttons/CoinsLabel.text = str(GameState.player_coins)
	$Buttons/KillsLabel.text = str(GameState.enemies_killed)
	
	if visible:
		$Sound.play()
