extends CharacterBody2D

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if visible:
		rotation += 4 * PI * delta

func _physics_process(_delta: float) -> void:
	if visible:
		move_and_slide()

func _on_enemy_detector_body_entered(body: Node2D) -> void:
	print("Bullet body.name: ", body.name)
	if body.name == "WorldBoundary":
		(get_parent() as BulletPool).return_bullet(self)
	
	if body.is_in_group("Enemies"):
		var obj: EnemyBody = body as EnemyBody
		if obj.is_alive and obj.visible and self.visible:
			obj.take_damage(25.0)
			(get_parent() as BulletPool).return_bullet(self)
