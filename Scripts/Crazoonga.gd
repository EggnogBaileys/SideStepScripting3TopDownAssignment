extends CharacterBody3D

# Do not leave "magic numbers" in your code, give them constant names
const H_KNOCKBACK_FORCE := 40.0
const V_KNOCKBACK_FORCE := 25.0
const MAX_FALL_SPEED := -80.0

@onready var clawSwing = $ClawSwing
@onready var swingTimer = $ClawSwing/SwingTimer

@onready var clawAnimator = $Crazoonga/Claw
@onready var legAnimator = $Crazoonga/Legs

@export var canSwing = true

@export var walkSpeed = 10.0
@export var turnSpeed = 5.0

# If shells are 0 and crab is hit, crab perishes.
# With each shell found, crab can take one extra hit.
var shells = 0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
# Declare variables that are used every frame only once, for performance
var knockback := Vector3.ZERO
var direction: float

func _physics_process(delta):

	velocity = SideStep() if $Knockback.is_stopped() else knockback
	if Input.is_action_pressed("ClawSwing") and canSwing:
		Swing()

	velocity.y -= gravity * delta \
		if not is_on_floor() or velocity.y < MAX_FALL_SPEED \
		else 0
	rotate_y(Input.get_axis("ui_right", "ui_left") * turnSpeed * delta)
	move_and_slide()
	

func SideStep() -> Vector3:

	direction = Input.get_axis("ui_down", "ui_up") * walkSpeed

	if direction:
		legAnimator.play("Walk")
	else:
		legAnimator.play("Idle")

	return Vector3(
		transform.basis.z.x * direction, 
		velocity.y, 
		transform.basis.z.z * direction
	)

# I didn't touch the swinging
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

func _on_damage_taken(hazard: Node3D):
	if not $Knockback.is_stopped():
		return
	$Knockback.start()

	knockback = global_transform.origin - hazard.global_transform.origin
	knockback = knockback.normalized() * H_KNOCKBACK_FORCE
	knockback.y = V_KNOCKBACK_FORCE

	var tween := create_tween()
	# PhysicsBody-related activities should be synced to physics frames
	# Notice how the $Knockback timer's process callback is "Physics", too
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

	tween.tween_property(self, "knockback", Vector3(0,-10, 0), $Knockback.wait_time)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
			
			
			
# In Unity we refer to ourself through "this", in Godot we use "self".
