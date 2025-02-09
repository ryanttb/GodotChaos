extends Node

@export var mob_scene: PackedScene

func _ready() -> void:
	$UserInterface/Retry.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# restart current scene
		get_tree().reload_current_scene()

func _on_mob_timer_timeout() -> void:
	# create a new instance of Mob
	var mob: MobBody3D = mob_scene.instantiate()
	
	# choose a random location along SpawnPath
	var mob_spawn_location: PathFollow3D = $SpawnPath/SpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player3D.position	
	mob.initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)

	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	
func _on_player_3d_hit() -> void:
	$MobTimer.stop()
	
	$UserInterface/Retry.show()
