extends Node3D

class_name BalloonPopperMain

@export var score_text: Label

var score := 0

func increase_score(amount: int):
	score += amount
	#%ScoreLabel.text = str("Score: ", score)
	score_text.text = str("Score: ", score)
