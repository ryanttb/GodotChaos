class_name EnemyBody
extends CharacterBody2D

signal enemy_killed(enemy: EnemyBody)

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Players")
@onready var sprite: Sprite2D = get_node("Sprite")
@onready var health_bar: ProgressBar = get_node("HealthBar")
@onready var death_animation: AnimatedSprite2D = get_node("DeathAnimation")

var is_alive := true
var health := 100.0
var damage := 10.0

func _ready() -> void:
	print("EnemyBody collision_layer: ", collision_layer)

func _on_death_animation_animation_finished() -> void:
	enemy_killed.emit(self)

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body == player: # just to be sure
		player.take_damage(damage)

# Override this but be sure to call it
func set_alive() -> void:
	death_animation.hide()
	collision_layer = 0b10
	is_alive = true
	health = 100.0
	health_bar.value = health

func take_damage(amount: float) -> void:
	health -= amount
	
	if is_instance_valid(health_bar):
		health_bar.value = health
	
	if health <= 0:
		kill()

func kill() -> void:
	collision_layer = 0
	is_alive = false
	if is_instance_valid(death_animation):
		
		death_animation.show()
		death_animation.play("death")
		# could also: await death_animation.animation_finished
	else:
		enemy_killed.emit(self)
