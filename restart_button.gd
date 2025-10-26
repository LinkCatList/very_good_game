extends Button

func _on_restart_button_pressed():
	Bobrik.load_game()

func _ready():
	self.pressed.connect(_on_restart_button_pressed)
