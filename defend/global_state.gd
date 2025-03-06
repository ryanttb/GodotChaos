extends Node

var health := 100
var money := 1350

var wave := 0

var enemies_alive := 0

func reset() -> void:
	health = 100
	money = 1350
	wave = 0
	enemies_alive = 0
