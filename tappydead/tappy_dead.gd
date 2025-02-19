extends Node

class_name TappyDeadScene

var health_decrease_speed := 10
var health_increase_coin := 25.0
var health := 100.0
var score := 0.0

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if health > 0.0:
		set_health(health - health_decrease_speed * delta)
		set_score(score + delta)

func _on_coin_collided(body: Node2D, coin_instance: Area2D = null) -> void:
	if body.is_in_group("Player"):
		set_health(health + health_increase_coin)
		$CoinCollectedAudio.play()
		var ap: AnimationPlayer = coin_instance.get_node("AnimationPlayer")
		ap.play("Collected")
		

func _on_obstacle_collided(body: Node2D, _obstacle_instance: Area2D = null) -> void:
	if body.is_in_group("Player"):
		game_over()
	
func set_health(new_health: float) -> void:
	if new_health <= 0:
		new_health = 0
		game_over()
		
	if new_health > 100:
		new_health = 100

	health = new_health
	$GUI/HealthBar.value = health
	
func set_score(new_score: float) -> void:
	score = new_score
	var formatted_score = str(score)
	var decimal_index = formatted_score.find(".")
	formatted_score = formatted_score.left(decimal_index + 2)
	$GUI/HealthBar/Label.text = formatted_score


func _on_play_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func game_over() -> void:
	$GameOverAudio.play()
	$GameOver.show()
	get_tree().paused = true
	
