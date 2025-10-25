extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var check_collisions_nodes: Array

func register_node(node: Node):
	check_collisions_nodes.append(node)

func check_at_position(position: Vector2):
	for node in check_collisions_nodes:
		# проверяем коллизию
		return node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
