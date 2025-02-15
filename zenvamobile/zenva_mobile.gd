extends Control

@export var game_time := 12

var score := 0
var time_left = game_time

var aim_score := 23

func _ready() -> void:
	time_left = game_time
	update_time_left(game_time)
	update_aim_score(aim_score)

func _on_increase_button_pressed() -> void:
	score += 1
	$ScoreLabel.text = "Score: " + str(score)
	Input.vibrate_handheld(125)
	#Input.start_joy_vibration(0, 1.0, 1.0, 0.125)
	
	if score == aim_score:
		get_tree().change_scene_to_file("res://you_win.tscn")


func _on_game_timer_timeout() -> void:
	update_time_left(time_left - 1)
	if time_left <= 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
	
func update_time_left(time: int) -> void:
	time_left = time
	$TimeLeftLabel.text = "Time left: " + str(time_left)
	
func update_aim_score(score: int) -> void:
	aim_score = score
	$AimScoreLabel.text = "Aim Score: " + str(aim_score)
