extends Button

func _on_restart_button_pressed():
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()

func _ready():
	self.pressed.connect(_on_restart_button_pressed)
