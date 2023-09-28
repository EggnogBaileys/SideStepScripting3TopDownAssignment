extends CharacterBody3D

# Do not leave "magic numbers" in your code, give them constant names
const H_KNOCKBACK_FORCE := 40.0
const V_KNOCKBACK_FORCE := 25.0
const MAX_FALL_SPEED := -80.0

@onready var clawSwing = $ClawSwing
@onready var swingTimer = $ClawSwing/SwingTimer

@onready var clawAnimator = $Crazoonga/Claw
@onready var legAnimator = $Crazoonga/Legs

var canSwing = true

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
	# Only multiply by delta if the velocity is modified (+=, -=...)
	# Do not multiply by delta if the velocity is simply assigned with =
	# Ternary operator, equivalent to "if test: x = true; else: x = false"
	velocity = SideStep() if $Knockback.is_stopped() else knockback
	if Input.is_action_pressed("ClawSwing") and canSwing:
		Swing()
	velocity.y -= gravity * delta \
		if not is_on_floor() or velocity.y < MAX_FALL_SPEED \
		else 0
	rotate_y(Input.get_axis("ui_right", "ui_left") * turnSpeed * delta)
	move_and_slide()


func SideStep() -> Vector3:
	# The most compact way to get the direction of inputs
	direction = Input.get_axis("ui_down", "ui_up") * walkSpeed
	# There are more flexible ways to setup animations, but this works for now
	if direction:
		legAnimator.play("Walk")
	else:
		legAnimator.play("Idle")
	# Using basis manipulation to get the desired movement
	# I could have used Euler angles, or Quaternions, if desired
	# As a matter of style, I prefer more functional code that does
	# not modify "velocity" outside of "_physics_process"
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

# You can connect multiple signals to the same function
# You can also name your connected functions whatever you want
#
# Notice how the function doesn't check who touched it, and only runs when
# walking on damaging objects. The CrazoongaArea3D has its collision mask set
# to 4, which I have named "hazard", and $EnemyHurtbox has its collision
# layer set to 4, "hazard" also
# Think of a collision mask as "reading all physics objects that affect this
# layer," and a collision layer as "affecting the layer."
func _on_damage_taken(by: Area3D):
	# Cooldown after damage is taken
	if not $Knockback.is_stopped():
		# Notice how instead of nesting all code below inside an "if",
		# it stops here, leaving us a lot more indentation space
		return
	$Knockback.start()

	# Calculate the desired angle of the knockback
	knockback = global_transform.origin - by.global_transform.origin
	knockback = knockback.normalized() * H_KNOCKBACK_FORCE
	knockback.y = V_KNOCKBACK_FORCE

	var tween := create_tween()
	# PhysicsBody-related activities should be synced to physics frames
	# Notice how the $Knockback timer's process callback is "Physics", too
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	# Slowly stop horizontal knockback and ground vertical knockback
	tween.tween_property(self, "knockback", Vector3(0,-10, 0), $Knockback.wait_time)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
