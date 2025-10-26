extends Node

var game_data = {
	"player_position": Vector2.ZERO,
	"camera_position": Vector2.ZERO,
	"super_bondage_activated": false,
	"pickaxe_activated": false,
	"music_player_activated": false,
	"food_activated": false,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func save_game():
	pass

func load_game():
	get_tree().current_scene.queue_free()
	var current_scene = load("res://node_2d.tscn").instantiate()
	var new_scene = load("res://node_2d.tscn")
	var instance = new_scene.instantiate()
	
	# Add to tree
	get_tree().root.add_child(instance)
	get_tree().current_scene = instance

	var player = Tools.find_nodes_custom(get_tree().root, func(n):
		return n.name == "Zombak"
	)
	player.position = game_data["player_position"]
	var camera = Tools.find_nodes_custom(get_tree().root, func(n):
		return n.name == "Camera2D"
	)
	camera.position = game_data["camera_position"]
	if game_data["super_bondage_activated"]:
		player.activate_super_bondage()
	if game_data["pickaxe_activated"]:
		player.activate_pickaxe()
	if game_data["music_player_activated"]:
		player.activate_music()
	if game_data["food_activated"]:
		player.activate_food()
	if game_data["food_activated"]:
		player.activate_food()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
