extends Area2D

@export var speed := 256.0

func _process(delta: float) -> void:
	position.y -= speed * delta

func animated_free() -> void:
	$PickaxeSprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$TrailParticles.emitting = false
	$ExplosionParticles.emitting = true

func _on_explosion_particles_finished() -> void:
	queue_free()
