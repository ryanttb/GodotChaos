class_name EnemyBulletBody
extends CharacterBody2D

@onready var bullet_pool: EnemyBulletPool = get_parent()

var active := false

var damage := 5.0

func _ready() -> void:
	if not is_instance_valid(bullet_pool):
		print("[ERROR] EnemyBullet bullet_pool invalid")
	
func _process(delta: float) -> void:
	if active:
		rotation += 4 * PI * delta

func _physics_process(_delta: float) -> void:
	if active:
		move_and_slide()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if not active:
		return
	
	print("EnemyBullet body.name: ", body.name)
	
	if body.name == "WorldBoundary":
		bullet_pool.return_bullet(self)
	
	if body.is_in_group("Players"):
		var obj: PlayerBody = body
		obj.take_damage(damage)
		bullet_pool.return_bullet(self)

func activate() -> void:
	$PlayerDetector.monitoring = true
	active = true
	show()

func deactivate() -> void:
	hide()
	active = false
	$PlayerDetector.monitoring = false
	velocity = Vector2.ZERO
	position = Vector2(-1024, -1024)
