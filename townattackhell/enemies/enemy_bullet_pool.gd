class_name EnemyBulletPool
extends Node

var BulletScene: PackedScene = preload("res://enemies/enemy_bullet.tscn")

var pool_size := 16
var bullet_pool: Array[Node2D] = []

func _ready() -> void:
	add_to_pool(pool_size)

func add_to_pool(size: int):
	for i in size:
		var obj: EnemyBulletBody = BulletScene.instantiate()
		obj.deactivate()
		bullet_pool.append(obj)
		add_child(obj)
	print("EnemyBulletPool size: " + str(bullet_pool.size()))

func get_bullet() -> Node2D:
	for bullet in bullet_pool:
		var bullet_body: EnemyBulletBody = bullet
		if not bullet_body.active:
			bullet_body.activate()
			return bullet
	
	add_to_pool(pool_size)
	return get_bullet()

func return_bullet(bullet: Node2D) -> void:
	var bullet_body: EnemyBulletBody = bullet
	bullet_body.deactivate()
