class_name CharacterBase
extends CharacterBody2D

const GRID_SIZE := 16


func _ready() -> void:
	pass

func query_ray(start_pos: Vector2, direction: Vector2) -> Dictionary:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_pos, start_pos + GRID_SIZE * direction)
	
	# will have all info about collisions of ray
	return space_state.intersect_ray(query)

func is_wall_in_direction(direction: Vector2) -> bool:
	# start ray slightly offset from character position to avoid edge cases
	var start_pos = global_position + direction * 1.0
	var result = query_ray(start_pos, direction)
	
	# return true if ray hit a wall
	return result and result.collider.is_in_group("Walls")

func random_direction() -> Vector2:
	var directions = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
	directions.shuffle()
	return directions[0]

# takes damage from another character
# should be overridden by subclasses
func take_damage(amount: int) -> void:
	print("CharacterBase unimplemented take_damage: ", amount)
	pass
