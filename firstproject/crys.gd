extends Node

@export var bug_scene: PackedScene

var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_hit() -> void:
	game_over()

func _on_bug_timer_timeout() -> void:
	# create new bug
	var bug: RigidBody2D = bug_scene.instantiate()
	
	# get random float along path
	var bug_spawn_location: PathFollow2D = $BugPath/BugSpawnLocation
	bug_spawn_location.progress_ratio = randf()
	
	# rotate half pi to be perpendicular from spawn location direction
	# which is along the perimiter of the path
	var direction = bug_spawn_location.rotation + PI / 2
	
	# set bug position
	bug.position = bug_spawn_location.position
	
	# add some randomness
	direction += randf_range(-PI/4, PI/4)
	bug.rotation = direction
	
	# choose velocity (direction & speed)
	var velocity := Vector2(randf_range(150.0, 250.0), 0.0)
	bug.linear_velocity = velocity.rotated(direction)
	
	# add the bug to scene
	add_child(bug)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)	

func _on_start_timer_timeout() -> void:
	$BugTimer.start()
	$ScoreTimer.start()

func _on_hud_start_game() -> void:
	new_game()

func game_over() -> void:
	$ScoreTimer.stop()
	$BugTimer.stop()
	
	$Music.stop()
	$DeathSound.play()
	
	$HUD.show_game_over()
	
func new_game() -> void:	
	get_tree().call_group("bugs", "queue_free")
	
	var noise_texture: NoiseTexture2D = $TextureRect.texture
	var noise: FastNoiseLite = noise_texture.noise
	noise.seed = randi_range(0, 32676)
	
	score = 0
	
	$HUD.update_score(score)
	$HUD.show_message(&"Get Ready")
	
	$Player.start($StartPosition.position)
	$StartTimer.start()	
	
	$Music.play()
