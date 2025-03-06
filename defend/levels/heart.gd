extends Node3D

@export_group("Enemies")
@export var UFO: PackedScene
@export var num_ufos := 3

@export_group("Weapons")
@export var CannonScene: PackedScene
@export var BlasterScene: PackedScene

@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var indicator: MeshInstance3D = $WoodStructure

@onready var indicator_material: BaseMaterial3D = preload("res://assets/Textures/indicator_material.tres")

var can_spawn := true
var spawned_ufos := 0

var last_hover_node: CollisionObject3D
var in_build_menu := false
var in_wave := false

func _ready() -> void:
	set_money(GlobalState.money)

func _process(_delta: float) -> void:
	check_spawn_ufo()
	handle_player_controls()
	update_ui()

func _on_spawn_timer_timeout() -> void:
	can_spawn = true

func update_ui() -> void:
	in_wave = GlobalState.enemies_alive > 0
	
	$CanvasLayer/UI/Wave.text = "Wave " + str(GlobalState.wave)
	$CanvasLayer/UI/NextWaveButton.visible = not in_wave
	
	var tower_health: HealthBar3D = $Tower/TowerHealth
	tower_health.update(GlobalState.health)

func check_spawn_ufo() -> void:
	if spawned_ufos < num_ufos and can_spawn:
		var ufo = UFO.instantiate()
		var ufo_body: EnemyBody = ufo.get_node("UFOBody")
		if is_instance_valid(ufo_body):
			ufo_body.enemy_defeated.connect(_on_enemy_defeated)
		$Path.add_child(ufo)
		spawned_ufos += 1
		GlobalState.enemies_alive += 1
		can_spawn = false

func handle_player_controls() -> void:
	if GlobalState.health <= 0:
		game_over()
	
	if in_build_menu:
		if Input.is_action_just_pressed("ui_cancel"):
			$CanvasLayer/UI/ShopPanel.hide()
			in_build_menu = false
	else:
		var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		
		var origin: Vector3 = camera.project_ray_origin(mouse_pos)
		var end: Vector3 = origin + camera.project_ray_normal(mouse_pos) * 100 # why multiply?
		
		var ray: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
		ray.collide_with_bodies = true
		
		var ray_result: Dictionary = space_state.intersect_ray(ray)
		
		if last_hover_node:
			var tile_node: MeshInstance3D = last_hover_node.get_node("Tile") as MeshInstance3D
			tile_node.set_surface_override_material(1, null)
		
		if ray_result.size() > 0:
			var collider: CollisionObject3D = ray_result.get("collider") as CollisionObject3D
			
			if collider.is_in_group("Buildable") or collider.is_in_group("Path"):
				indicator.global_position = collider.global_position + Vector3(0, .25, 0)
				indicator.show()
			
			if collider.is_in_group("Buildable"):
				indicator.set_surface_override_material(0, indicator_material)
				
				var tile_node: MeshInstance3D = collider.get_node("Tile") as MeshInstance3D
				if tile_node:
					var surface: StandardMaterial3D = tile_node.mesh.surface_get_material(1).duplicate() as StandardMaterial3D
					if surface:
						surface.rim_enabled = true
						tile_node.set_surface_override_material(1, surface)
						last_hover_node = collider
				
				if Input.is_action_just_pressed("tap"):
					$CanvasLayer/UI/ShopPanel.show()
					in_build_menu = true
			else:
				indicator.set_surface_override_material(0, null)
		else:
			indicator.hide()

func _on_buy_cannon_pressed() -> void:
	buy_weapon(250, CannonScene)

func _on_buy_blaster_pressed() -> void:
	buy_weapon(400, BlasterScene)

func _on_cancel_button_pressed() -> void:	
	$CanvasLayer/UI/ShopPanel.hide()
	in_build_menu = false

func _on_next_wave_button_pressed() -> void:
	GlobalState.wave += 1
	spawned_ufos = 0
	num_ufos = GlobalState.wave * 3
	can_spawn = true
	$SpawnTimer.start()

func _on_enemy_defeated(payout: int) -> void:
	set_money(GlobalState.money + payout)

func _on_play_again_pressed() -> void:
	GlobalState.reset()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()

func game_over() -> void:
	get_tree().paused = true
	$CanvasLayer/UI/GameOverPanel.show()

func buy_weapon(cost: int, scene: PackedScene) -> void:
	if cost <= GlobalState.money:
		if last_hover_node:
			var obj = scene.instantiate()
			add_child(obj)
			obj.global_position = last_hover_node.global_position + Vector3(0, 0.2, 0)
		
		set_money(GlobalState.money - cost)
		
		$CanvasLayer/UI/ShopPanel.hide()
		in_build_menu = false

func set_money(amount: int) -> void:
	print("Heart set_money amount: ", amount)
	GlobalState.money = amount
	$CanvasLayer/UI/Currency.text = "¤ " + str(GlobalState.money)
