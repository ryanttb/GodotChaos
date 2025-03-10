class_name EnemySpawner
extends Area2D

@onready var GuardianSerpentScene = preload("res://enemies/guardian_serpent.tscn")

var pool_size := 4
var enemy_pool: Array[Node2D] = []

func _ready() -> void:
	add_to_pool(pool_size)

func add_to_pool(size: int):
	for i in size:
		var obj: EnemyBody = GuardianSerpentScene.instantiate() as EnemyBody
		obj.visible = false
		obj.enemy_killed.connect(_on_enemy_killed)
		enemy_pool.append(obj)
		$EnemyPool.add_child(obj)
	print("EnemyPool size: " + str(enemy_pool.size()))

func get_enemy() -> Node2D:
	for enemy in enemy_pool:
		if not enemy.visible:
			return enemy
	
	add_to_pool(pool_size)
	return get_enemy()

func return_enemy(enemy: Node2D) -> void:
	var obj: EnemyBody = enemy as EnemyBody
	obj.visible = false

func _on_spawn_timer_timeout() -> void:
	var obj: EnemyBody = get_enemy()
	obj.global_position = global_position
	obj.set_alive()
	obj.show()

func _on_enemy_killed(enemy: EnemyBody) -> void:
	return_enemy(enemy)
