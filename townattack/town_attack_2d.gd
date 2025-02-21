extends Node2D

@export var pickaxe: PackedScene
@export var block: PackedScene

@export var block_spawn_x: Array[float]

var min_block_health := 2
var max_block_health := 7

var num_blocks := 1

func _on_attack_rate_timer_timeout() -> void:
	var weapon_instance: Area2D = pickaxe.instantiate()
	$Weapons.add_child(weapon_instance)
	weapon_instance.position = $Princess.position + Vector2(0, -16)

func _on_block_spawn_timer_timeout() -> void:
	var spots: Array[int] = []
	
	# this seems not optimized, but it works
	# if randi keeps returning the same value by chance,
	# while will loop a lot
	for i in range(num_blocks):
		var random_spot := randi() % block_spawn_x.size()
		while spots.find(random_spot) != -1:
			random_spot = randi() % block_spawn_x.size()
		spots.append(random_spot)

	for spot in spots:
		var block_instance: BlockControl = block.instantiate()
		block_instance.set_health(randi_range(min_block_health, max_block_health))
		$Enemies.add_child(block_instance)
		block_instance.position.x = block_spawn_x[spot]
		block_instance.position.y = -108
		
		var main: TownAttackMain = get_tree().get_first_node_in_group("Main")
		block_instance.weapon_hit.connect(main.increase_score)

func _on_progression_timer_timeout() -> void:
	if num_blocks < 4:
		num_blocks += 1
		min_block_health = 5 * (num_blocks - 1)
		max_block_health = 5 * num_blocks
		$AttackRateTimer.wait_time -= 0.025
