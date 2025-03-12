class_name BulletBody
extends CharacterBody2D

@onready var bullet_pool: BulletPool = get_parent()

var active := false

func _ready() -> void:
	if not is_instance_valid(bullet_pool):
		print("[ERROR] Bullet bullet_pool invalid")
	
func _process(delta: float) -> void:
	if active:
		rotation += 4 * PI * delta

func _physics_process(_delta: float) -> void:
	if active:
		move_and_slide()

func _on_enemy_detector_body_entered(body: Node2D) -> void:
	if not active:
		return
	
	print("Bullet body.name: ", body.name)
	
	if body.name == "WorldBoundary":
		bullet_pool.return_bullet(self)
	
	if body.is_in_group("Enemies"):
		var obj: EnemyBody = body as EnemyBody
		if obj.is_alive and obj.visible:
			obj.take_damage(25.0)
			bullet_pool.return_bullet(self)

func activate() -> void:
	$EnemyDetector.monitoring = true
	active = true
	show()

func deactivate() -> void:
	hide()
	active = false
	$EnemyDetector.monitoring = false
	velocity = Vector2.ZERO
	position = Vector2(-1024, -1024)
