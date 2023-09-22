extends CharacterBody3D


@export var maxWalkSpeed = 1200.0
@export var walkSpeed = 1200.0
@export var turnSpeed = 5.0


func _physics_process(delta):

	velocity = Vector3().normalized()

	var rotation_direction = 0
	
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
	
		walkSpeed = walkSpeed / 1.1
	
		if Input.is_action_pressed("ui_left"):
			rotation_direction += 1
		if Input.is_action_pressed("ui_right"):
			rotation_direction -= 1	
			
		rotation.y += turnSpeed * rotation_direction * delta
	
	else:
		
		walkSpeed = maxWalkSpeed
	
	
	
	if Input.is_action_pressed("ui_up"):
		velocity = Vector3(0, 0, walkSpeed * delta).rotated(Vector3.UP, rotation.y)

	if Input.is_action_pressed("ui_down"):
		velocity = Vector3(0, 0, -walkSpeed * delta).rotated(Vector3.UP, rotation.y)



	move_and_slide()
