extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()

func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over() -> void:
	show_message(&"Game Over")
	
	# wait for message timer
	await $MessageTimer.timeout
	
	$Message.text = &"Dodge the Bugs!"
	$Message.show()
	
	# wait a second, then show start button
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score) -> void:
	$ScoreLabel.text = str(score)
