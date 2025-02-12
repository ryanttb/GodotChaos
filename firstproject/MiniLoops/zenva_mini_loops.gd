extends Node2D

@export var spawn_count := 200

var star_scene := preload("res://MiniLoops/zenva_mini_loops_star.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in spawn_count:
		var star: Sprite2D = star_scene.instantiate()
		add_child(star)
		
		var viewport_rect: Rect2 = get_viewport_rect()
		var view_size = viewport_rect.size * 2
		star.position.x = randi_range(-view_size.x, view_size.x)
		star.position.y = randi_range(-view_size.y, view_size.y)
		
		var star_size = randf_range(0.2, 0.8)
		star.apply_scale(Vector2.ONE * star_size)
		
		star.modulate.a = randf_range(0, 1)
