class_name ObjectPool
extends Node

@export var object_scene: PackedScene
@export var pool_increment: int = 32

var pool: Array[Node2D] = []

func _ready() -> void:
	_add_objects_to_pool(pool_increment)

func _create_object() -> Node2D:
	var object: Node2D = object_scene.instantiate()
	_disable_object(object)
	pool.append(object)
	add_child(object)
	return object

func _disable_object(object: Node2D) -> void:
	object.process_mode = Node.PROCESS_MODE_DISABLED
	object.visible = false
	object.global_position = Vector2(-1000, -1000)

func _is_object_active(object: Node2D) -> bool:
	return object.process_mode != Node.PROCESS_MODE_DISABLED

func _enable_object(object: Node2D) -> void:
	object.visible = true
	object.process_mode = Node.PROCESS_MODE_INHERIT

func _add_objects_to_pool(count: int) -> void:
	for i in count:
		_create_object()

func get_object() -> Node2D:
	for object in pool:
		if not _is_object_active(object):
			_enable_object(object)
			return object
	_add_objects_to_pool(pool_increment)
	return pool.back()

func return_object(object: Node2D) -> void:
	_disable_object(object)
