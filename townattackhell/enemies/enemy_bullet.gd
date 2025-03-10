extends CharacterBody2D

var damage := 5.0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if visible:
		rotation += 4 * PI * delta

func _physics_process(_delta: float) -> void:
	if visible:
		move_and_slide()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if not self.visible:
		return
	
	print("EnemyBullet body.name: ", body.name)
	if body.name == "WorldBoundary":
		(get_parent() as EnemyBulletPool).return_bullet(self)
	
	if body.is_in_group("Players"):
		var obj: PlayerBody = body
		obj.take_damage(damage)
		(get_parent() as EnemyBulletPool).return_bullet(self)
