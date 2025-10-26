extends Node

func _ready():
	pass

func _process(delta):
	pass

func move_and_collide_2_0_new_edition(node: Node, offset: Vector2):
	var point = node.global_position + offset
	var space_state = node.get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.set_position(point)
	var result = space_state.intersect_point(parameters, 4)
	
	print(result)
	
	if len(result) == 0:
		node.global_position += offset
	
	return result
