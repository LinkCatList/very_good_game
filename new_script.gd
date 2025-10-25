extends RigidBody2D

var SPEED = 132

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_vector = Vector2.ZERO
	if Input.is_action_just_pressed("move_left"):
		move_vector.x -= SPEED
	if Input.is_action_just_pressed("move_right"):
		move_vector.x += SPEED
	if Input.is_action_just_pressed("move_up"):
		move_vector.y -= SPEED
	if Input.is_action_just_pressed("move_down"):
		move_vector.y += SPEED
	
	var collide_result = move_and_collide(move_vector)
	if collide_result != null and collide_result.get_collider_shape().get_parent().has_method("move"):
		collide_result.get_collider_shape().get_parent().move(move_vector)
		
	pass
