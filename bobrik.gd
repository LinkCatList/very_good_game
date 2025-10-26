extends Node

var game_data = {
	"player_position": Vector2.ZERO,
	"camera_position": Vector2.ZERO,
	"bondage": false,
	"pickaxe": false,
	"music_player": false,
	"food": false,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Bobrik.go_to_level(1)
	pass # Replace with function body.

func save_game():
	var player = Tools.find_nodes_custom(get_tree().root, func(n):
		return n.name == "Zombak"
	)[0]
	var camera = Tools.find_nodes_custom(get_tree().root, func(n):
		return n.name == "Camera2D"
	)[0]
	game_data["player_position"] = player.global_position
	game_data["camera_position"] = camera.global_position
	game_data.merge(player.targets_state, true)
	print(game_data)
	pass

func go_to_level(level):
	var camera_position = Tools.find_nodes_custom(get_tree().root, func(n):
		return n.name == "CameraLevel" + str(level)
	)[0]
	var player_position = Tools.find_nodes_custom(get_tree().root, func(n):
		return n.name == "PlayerPosLevel" + str(level)
	)[0]
	var player = Tools.find_nodes_custom(get_tree().root, func(n):
		return n.name == "Zombak"
	)[0]
	var camera = Tools.find_nodes_custom(get_tree().root, func(n):
		return n.name == "Camera2D"
	)[0]
	player.global_position = player_position.global_position
	camera.global_position = camera_position.global_position
	save_game()

func load_state():
	var player = Tools.find_nodes_custom(get_tree().root, func(n):
		return n.name == "Zombak"
	)[0]
	player.global_position = game_data["player_position"]
	var camera = Tools.find_nodes_custom(get_tree().root, func(n):
		return n.name == "Camera2D"
	)[0]
	camera.global_position = game_data["camera_position"]
	if game_data["bondage"]:
		player.activate_super_bondage()
	if game_data["pickaxe"]:
		player.activate_pickaxe()
	if game_data["music_player"]:
		player.activate_music()
	if game_data["food"]:
		player.activate_food()

func load_game():
	get_tree().current_scene.queue_free()
	var new_scene = load("res://node_2d.tscn")
	var instance = new_scene.instantiate()
	
	# Add to tree
	get_tree().root.add_child(instance)
	get_tree().current_scene = instance
	await get_tree().create_timer(0.01).timeout
	load_state()
	
func _process(delta):
	pass

func move_and_collide_2_0_new_edition(node: Node, offset: Vector2):
	var point = node.global_position + offset
	var space_state = node.get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.set_position(point)
	var result = space_state.intersect_point(parameters, 4)
	
	
	#if len(result) == 0:
		#node.global_position += offset
	
	return result
