extends RigidBody2D

var SPEED = 132
@onready
var bondage = $Bondage
@onready
var superBondage = $SuperBondage
@onready
var pickaxeHandle = $Pickaxe

var pickaxe = false
var canUsePickaxe = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canUsePickaxe = true
	activate_super_bondage()
	activate_pickaxe()
	pass # Replace with function body.

func activate_super_bondage():
	superBondage.visible = true
	bondage.visible = false

func activate_pickaxe():
	pickaxe = true


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
		
	
	var result = Bobrik.move_and_collide_2_0_new_edition(self, move_vector)
	if len(result) > 0:
		var object = result[0]["collider"]
		
		if object.scene_file_path.get_file().get_basename() == "grave":
			if pickaxeHandle.visible:
				object.queue_free()
				canUsePickaxe = false
				pickaxeHandle.visible = false
			else:
				object.move(move_vector)
	
	if canUsePickaxe and Input.is_action_just_pressed("action"):
		pickaxeHandle.visible = not pickaxeHandle.visible
		
	pass
