extends Control

class_name BlockControl

@export var colors: Array[Color]
@export var speed := 128.0

signal weapon_hit

var health := 5

func _ready() -> void:
	$Visuals/Background.color = colors[randi() % colors.size()]
	$Particles.color = $Visuals/Background.color
	set_health(health)

func _process(delta: float) -> void:
	position.y += speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Weapons"):
		set_health(health - 1)
		if health <= 0:
			var main: TownAttackMain = get_tree().get_first_node_in_group("Main")
			main.set_time_left(10, true)
			$Area2D/CollisionShape2D.set_deferred("disabled", true)
			$Visuals.hide()
			$Particles.emitting = true
			
		if area.has_method("animated_free"):
			area.animated_free()
		else:
			area.queue_free()
		weapon_hit.emit(1)
		

func _on_particles_finished() -> void:
	queue_free()

func set_health(new_health: int) -> void:
	health = new_health
	$Visuals/HealthLabel.text = str(health)
