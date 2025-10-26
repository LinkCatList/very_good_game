extends RigidBody2D

var SPEED = 132
@onready
var bondage = $Bondage
@onready
var superBondage = $SuperBondage
@onready
var pickaxeHandle = $Pickaxe

@onready
var Targets = $"../Camera2D/Targets"
@onready
var BondageTarget = Targets.get_node("Bondage")
@onready
var PickAxeTarget = Targets.get_node("Pickaxe")
@onready
var MusicPlayerTarget = Targets.get_node("MusicPlayer")
@onready
var FoodTarget = Targets.get_node("Food")
@onready
var BalloonTarget = Targets.get_node("Balloon")
@onready
var MusicPlayer2D = $"../MusicPlayer2D"

var targets_state: Dictionary = {
	"bondage": false,
	"pickaxe": false,
	"music_player": false,
	"food": false,
	"balloon": false,
}

func activate_target(target: Sprite2D, animated: Variant = null):
	target.modulate = Color.WHITE
	if animated != null:
		var animatedVersion = load(animated).instantiate()
		animatedVersion.transform = target.transform
		target.replace_by(animatedVersion)

var pickaxe = false
var canUsePickaxe = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(global_position)
	#activate_super_bondage()
	#activate_pickaxe()
	pass # Replace with function body.

func activate_super_bondage():
	superBondage.visible = true
	bondage.visible = false
	targets_state["bondage"] = true
	activate_target(BondageTarget)

func activate_pickaxe():
	canUsePickaxe = true
	pickaxe = true
	targets_state["pickaxe"] = true
	activate_target(PickAxeTarget)
	
func activate_music():
	MusicPlayer2D.stream = load("res://music/music.mp3")
	MusicPlayer2D.play()
	targets_state["music_player"] = true
	activate_target(MusicPlayerTarget, "res://sprites/MusicPlayer/AnimatedMusicPlayer.tscn")
	pass

func activate_food():
	targets_state["food"] = true
	activate_target(FoodTarget, "res://sprites/Mushroom/AnimatedMushroom.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_vector = Vector2.ZERO
	if Input.is_action_just_pressed("move_left"):
		move_vector.x -= SPEED
	elif Input.is_action_just_pressed("move_right"):
		move_vector.x += SPEED
	elif Input.is_action_just_pressed("move_up"):
		move_vector.y -= SPEED
	elif Input.is_action_just_pressed("move_down"):
		move_vector.y += SPEED
		
	
	var result = Bobrik.move_and_collide_2_0_new_edition(self , move_vector)
	if len(result) > 0:
		var object = result[0]["collider"]

		if object.scene_file_path.get_file().get_basename() == "teleport":
			Bobrik.go_to_level(object.get("level"))
			return

		if object.scene_file_path.get_file().get_basename() == "grave" or object.scene_file_path.get_file().get_basename() == "fake_wall":
			if pickaxeHandle.visible:
				object.queue_free()
				canUsePickaxe = false
				pickaxeHandle.visible = false
			else:
				object.move(move_vector)
				
		if object.scene_file_path.get_file().get_basename() == "pickaxe":
			object.queue_free()
			self.global_position += move_vector
			activate_pickaxe()

		if object.scene_file_path.get_file().get_basename() == "super_bondage":
			object.queue_free()
			self.global_position += move_vector
			activate_super_bondage()
			
		if object.scene_file_path.get_file().get_basename() == "music_player":
			object.queue_free()
			self.global_position += move_vector
			activate_music()
			
		if object.scene_file_path.get_file().get_basename() == "food":
			object.queue_free()
			self.global_position += move_vector
			activate_food()
			
		if object.scene_file_path.get_file().get_basename() == "balloon":
			object.queue_free()
			activate_target(BalloonTarget)
			self.global_position += move_vector

	else:
		self.global_position += move_vector
		
	
	if canUsePickaxe and Input.is_action_just_pressed("action"):
		pickaxeHandle.visible = not pickaxeHandle.visible
		
	pass
