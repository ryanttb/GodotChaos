extends Control

func _process(_delta: float) -> void:
	$ScoreLabel.text = "Score: " + str(GameState.score)

func _on_play_again_pressed() -> void:
	GameState.player_health = 100.0
	GameState.score = 0
	GameState.time_survived = 0.0
	
	get_tree().paused = false
	get_tree().reload_current_scene()
	#get_tree().change_scene_to_file("res://waves/wave_01.tscn")
