extends CharacterBody3D


@onready var clawSwing = $ClawSwing
@onready var swingTimer = $ClawSwing/SwingTimer

@onready var clawAnimator = $Crazoonga/Claw
@onready var legAnimator = $Crazoonga/Legs

var canSwing = true

@export var maxWalkSpeed = 1200.0
@export var walkSpeed = 1200.0
@export var turnSpeed = 5.0

# If shells are 0 and crab is hit, crab perishes.
# With each shell found, crab can take one extra hit.
var shells = 0

var knockback = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var canMove = true


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta	
	
	if canMove:
		SideStep(delta)
		Rotation(delta)
	
	if Input.is_action_pressed("ClawSwing") and canSwing:
		Swing()
		
	Knockback(delta)
	


func SideStep(delta):
	
	velocity = Vector3().normalized()
	if Input.is_action_pressed("ui_up"):
		velocity = Vector3(0, 0, walkSpeed * delta).rotated(Vector3.UP, rotation.y)
	if Input.is_action_pressed("ui_down"):
		velocity = Vector3(0, 0, -walkSpeed * delta).rotated(Vector3.UP, rotation.y)
	
	if velocity != Vector3.ZERO: 
		legAnimator.play("Walk")
	else: 
		legAnimator.play("Idle")
	
	move_and_slide()

func Rotation(delta):
		
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

func Swing():
	canSwing = false
	swingTimer.start()
	clawAnimator.play("Swing")
	$ClawSwing/Swing.play("Swing")
func _on_swing_timer_timeout():
	canSwing = true	
func _on_claw_animation_finished(anim_name):
	if anim_name == "Swing":
		clawAnimator.play("Default")


func Knockback(delta):
	#knockback = velocity.move_toward(Vector3.ZERO, delta * 200)
	#knockback = move_and_collide(knockback)
	pass






func _on_crazoonga_area_3d_area_entered(area):
	if area.name == "EnemyHurtbox":
		canMove = false
		print("are we even colliding")
		velocity = (global_transform.origin - area.global_transform.origin).normalized()
		velocity *= -10
		await get_tree().create_timer(0.8). timeout
		canMove = true
