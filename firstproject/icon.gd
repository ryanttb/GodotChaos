extends Node2D

signal icon_faced_up

signal icon_rotated(num_rotations: int)

var speed := 400
var angular_speed := PI # 3.14 radians / second
var num_rotations := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Icon _ready o hai")
	
	#var timer = $Timer
	var timer: Timer = get_node("Timer")
	timer.timeout.connect(_on_timer_timeout)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var direction := 0
	#if Input.is_action_pressed("ui_left"):
	#	direction -= 1
	#if Input.is_action_pressed("ui_right"):
	#	direction += 1
		
	#rotation += angular_speed * direction * delta
	
	rotation += angular_speed * delta

	if abs(fposmod(rotation, 2*PI)) < 0.05:
		icon_faced_up.emit()

	#var velocity = Vector2.ZERO
	#if Input.is_action_pressed("ui_up"):
	#	velocity = Vector2.UP.rotated(rotation) * speed
	
	var velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta


func _on_toggle_pressed() -> void:
	set_process(not is_processing())
	
func _on_timer_timeout():
	visible = not visible


func _on_icon_faced_up() -> void:
	print("Icon _on_icon_faced_up")
	num_rotations += 1;
	icon_rotated.emit(num_rotations)


func _on_icon_rotated(nrots: int) -> void:
	print("Icon _on_icon_rotated: " + str(nrots))
