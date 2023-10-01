extends CharacterBody3D

var players: Array[Node3D]

const H_KNOCKBACK_FORCE := 40.0

var knockback := Vector3.ZERO
var direction: float

@export var speed: float = 35.0
@export var max_speed: float = 35.0
@export var health: int = 3

var canMove: bool = false

func _physics_process(delta):

	players = $PlayerDetection.get_overlapping_bodies()

	if not players.is_empty():

		if canMove and $Knockback.is_stopped():

			velocity = velocity.move_toward(((players[0].position - position).normalized() * max_speed), \
			delta * speed)

			look_at(players[0].global_position)

		else: 
			velocity = knockback

		move_and_slide()



func _on_player_detection_body_entered(_body):
	$FlopTimer.start()


func _on_flop_timer_timeout():
	canMove = !canMove


func _on_hurtbox_area_entered(area):
	print_debug("Ouch")
	CalculateKnockback(area)
	health -= 1
	if health < 1:
		queue_free()


func CalculateKnockback(claw):

	if not $Knockback.is_stopped():
		return
	$Knockback.start()

	knockback = global_transform.origin - claw.global_transform.origin
	knockback = knockback.normalized() * H_KNOCKBACK_FORCE


	var tween := create_tween()

	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

	tween.tween_property(self, "knockback", Vector3(0, 0, 0), $Knockback.wait_time)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)


func _on_knockback_timeout():
	$Knockback.stop()
