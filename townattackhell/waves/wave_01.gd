extends Node2D

func _ready() -> void:
	$AliveTimer.start(2.5)
	
func _on_player_damage_taken(amount: float) -> void:
	GameState.player_health -= amount
	$UI/HUD/HealthBar.value = GameState.player_health
	if GameState.player_health <= 0:
		get_tree().paused = true
		$UI/GameOver.show()
		#get_tree().change_scene_to_file("res://ui/game_over.tscn")

func _on_enemy_spawner_enemy_killed(enemy: EnemyBody) -> void:
	GameState.score += enemy.points
	$UI/HUD/Score.text = "Score: " + str(GameState.score)

func _on_alive_timer_timeout() -> void:
	GameState.time_survived += 1
