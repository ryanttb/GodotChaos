extends Node

class_name TownAttackMain

var score := 0

@export var time_left := 10

func _ready() -> void:
	$HUD/TimeLeft.text = str(time_left)
	get_tree().paused = false

func _on_game_timer_timeout() -> void:
	set_time_left(time_left - 1)

func _on_play_again_button_pressed() -> void:
	get_tree().reload_current_scene()	

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")

func increase_score(amount: int = 1) -> int:
	score += amount
	$HUD/Score.text = "Score: " + str(score)
	return score

func set_time_left(time: int, reset: bool = false) -> void:
	time_left = time
	$HUD/TimeLeft.text = str(time_left)
	
	if time_left <= 0:
		game_over()
	
	if reset:
		$HUD/GameTimer.start(1)

func game_over() -> void:
	get_tree().paused = true
	$GameOver.show()
