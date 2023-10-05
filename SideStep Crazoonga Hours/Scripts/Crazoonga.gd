extends CharacterBody3D

# Unused for now
signal death

# Do not leave "magic numbers" in your code, give them constant names
const H_KNOCKBACK_FORCE := 40.0
const V_KNOCKBACK_FORCE := 25.0
const MAX_FALL_SPEED := -80.0
const DEFAULT_WALK_SPEED := 10.5
const DEFAULT_TURN_SPEED := 5.0
const DEFAULT_SHELL_COUNT := 0
const MAX_SHELL_COUNT := 3
const MIN_SHELL_COUNT := 0

enum Shell {
	NONE = MIN_SHELL_COUNT,
	BRONZE,
	SILVER,
	GOLD
}

@onready var clawSwing = $ClawSwing

@onready var clawAnimator = $Claw
@onready var legAnimator = $Legs

@export var canSwing = true

@export var walkSpeed = DEFAULT_WALK_SPEED
@export var turnSpeed = DEFAULT_TURN_SPEED

@onready var matchStick = $match
var hasMatch = false

# If shells are 0 and crab is hit, crab perishes.
# With each shell found, crab can take one extra hit.
# This is a setter. For each shell_count change, the function set_shell is run
var shell_count = 0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
# Declare variables that are used every frame only once, for performance
var knockback := Vector3.ZERO
var direction: float


@export var in_cutscene = false



func _physics_process(delta):
	
	if not in_cutscene:
		velocity = SideStep() if $Knockback.is_stopped() else knockback
		if Input.is_action_pressed("ClawSwing") and canSwing:
			Swing()

		velocity.y -= gravity * delta \
			if not is_on_floor() or velocity.y < MAX_FALL_SPEED \
			else 0
		rotate_y(Input.get_axis("ui_right", "ui_left") * turnSpeed * delta)
		move_and_slide()
	else:
		legAnimator.play("Idle")


func SideStep() -> Vector3:
	direction = Input.get_axis("ui_down", "ui_up") * walkSpeed
	legAnimator.play("Walk" if direction else "Idle")
	return Vector3(
		transform.basis.z.x * direction,
		velocity.y,
		transform.basis.z.z * direction
	)


func Swing():
	clawAnimator.play("Swing")


func _on_swing_timer_timeout():
	canSwing = true


func _on_claw_animation_finished(anim_name):
	if anim_name == "Swing":
		clawAnimator.play("Default")


func _on_contact(contact: Node3D):
	if contact.is_in_group("match"):
		grabMatch()
		contact.get_parent().queue_free()
		return
	if contact.is_in_group("log"):
		if hasMatch:
			contact.get_parent().animationPlayer.play("Burn")
		return
	if contact.is_in_group("firstShell"):
		$ShellPickup.play()
		shell_count += 1
		show_shells()
		contact.increment_progress()
		return
	if contact.is_in_group("shells"):
		if shell_count < MAX_SHELL_COUNT:
			shell_count += 1
			show_shells()
			$ShellPickup.play()
			contact.picked_up()
		return
	take_damage(contact)


func take_damage(hazard: Node3D):
	if shell_count < 0: 
		return
	
	if not $Knockback.is_stopped():
		return
	$Knockback.start()

	shell_count -= 1
	
	show_shells()
	
	if shell_count < 0:
		in_cutscene = true 
		rotate_z(180)
		$Death.play()
		await get_tree().create_timer(3.0).timeout
		Singleton.crabDeaths += 1
		get_tree().reload_current_scene()
		return
	
	$Hit.play()

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


func set_shells(shells: int):
	shell_count = clamp(shells, MIN_SHELL_COUNT, MAX_SHELL_COUNT)
	show_shells()
	print_debug("Shell count: ", shell_count)

func grabMatch():
	matchStick.show()
	hasMatch = true
	# enable collision through animation


func show_shells():
	if shell_count < 0:
		return
	# Mapping, all objects in the array have this function run on them.
	# It can be a regular function, or a Callable,which is like
	# a tiny function (like in this case).
	# I entered the nodes manually, but a more flexible way would be to
	# add all the shells to the group "shell_hats", and get all nodes in
	# this group. This returns an array, which can have a function mappted to it
	[$ShellA, $ShellB, $ShellC].map(func(s): s.hide())
	match shell_count:
		Shell.NONE: death.emit()
		Shell.BRONZE: $ShellA.show()
		Shell.SILVER: $ShellB.show()
		Shell.GOLD: $ShellC.show()
		_: assert(false, "Error: shell type '%s' not valid" % shell_count)
