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

var pedestals_enabled := 0

func _ready() -> void:
	generate_rocks()
	generate_trees()
	generate_pedestals()
	
	$NavMesh.bake_navigation_mesh()
	
	$HUD/PedestalCount.text = "Pedestals 0/%d" % [num_pedestals]

func _on_pedestal_enabled() -> void:
	pedestals_enabled += 1
	$HUD/PedestalCount.text = "Pedestals %d/%d" % [pedestals_enabled, num_pedestals]

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
