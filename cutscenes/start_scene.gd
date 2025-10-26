extends Node2D

func _ready():
	$AnimationPlayer.animation_finished.connect(func(anim):
		print("Animation finished")
		get_tree().current_scene.queue_free()
	
	# Load new scene
		var new_scene = load("res://node_2d.tscn")
		var instance = new_scene.instantiate()
		
		# Add to tree
		get_tree().root.add_child(instance)
		get_tree().current_scene = instance
	)
