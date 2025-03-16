extends Node3D

@export_group("Rocks")
@export var RockScene: PackedScene
@export var num_rocks := 24

@export_group("Trees")
@export var TreeScene: PackedScene
@export var num_trees := 24

@export_group("Pedestals")
@export var PedestalScene: PackedScene
@export var num_pedestals := 4

@export_group("Chalices")
@export var chalice_item: Item
@export var num_chalices := 8
@export var chalices_to_win := 5

var pedestals_enabled := 0
var chalices_found := 0

func _ready() -> void:
	generate_rocks()
	generate_trees()
	generate_pedestals()
	
	$NavMesh.bake_navigation_mesh()
	
	update_hud()
	
	GlobalSignals.on_give_player_item.connect(_on_give_player_item)

func _on_give_player_item(item: Item, amount: int) -> void:
	if item == chalice_item:
		chalices_found += amount
		update_hud()
		
		if chalices_found >= chalices_to_win:
			win_game()

func _on_pedestal_enabled() -> void:
	pedestals_enabled += 1
	update_hud()

func generate_rocks() -> void:
	for i in range(num_rocks):
		var obj: StaticBody3D = RockScene.instantiate()
		$NavMesh/Rocks.add_child(obj)
		obj.position.x = randf_range(-24, 24)
		obj.position.z = randf_range(-24, 24)
		obj.scale *= Vector3.ONE * randf_range(0.5, 3)
		obj.rotate_y(randf_range(0.2, 1.5))

func generate_trees() -> void:
	for i in range(num_trees):
		var obj: StaticBody3D = TreeScene.instantiate()
		$NavMesh/Trees.add_child(obj)
		obj.position.x = randf_range(-24, 24)
		obj.position.z = randf_range(-24, 24)
		obj.scale *= Vector3.ONE * randf_range(0.5, 3)
		obj.rotate_y(randf_range(0.2, 1.5))

func generate_pedestals() -> void:
	for i in range(num_pedestals):
		var obj: StaticBody3D = PedestalScene.instantiate()
		$NavMesh/Pedestals.add_child(obj)
		obj.position.x = randf_range(-24, 24)
		obj.position.z = randf_range(-24, 24)
		obj.rotate_y(randf_range(0.2, 1.5))
		obj.connect("pedestal_enabled", _on_pedestal_enabled)

func update_hud() -> void:
	$HUD/Counts/PedestalCount.text = "Pedestals %d" % [pedestals_enabled]
	$HUD/Counts/ChaliceCount.text = "Chalices %d" % [chalices_found]

func win_game() -> void:
	get_tree().paused = true
	$Screens/WinScreen.show()

func lose_game() -> void:
	get_tree().paused = true
	$Screens/LoseScreen.show()

func _on_play_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_try_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_bug_player_caught() -> void:
	lose_game()
