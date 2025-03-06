class_name UFOBody
extends EnemyBody

func _ready() -> void:
	super._ready()
	$HealthBar3D.init(max_health)

func _on_damage_taken() -> void:
	$HealthBar3D.update(health)
