extends Area2D

signal hit

@export var speed := 400
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity := Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:		
		velocity = velocity.normalized() * speed
		var animation = $AnimatedSprite2D.animation
		if velocity.x > 0:
			animation = "right"
		elif velocity.x < 0:
			animation = "left"
		elif velocity.y > 0:
			animation = "down"
		elif velocity.y < 0:
			animation = "up"
			
		$AnimatedSprite2D.play(animation)
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false
