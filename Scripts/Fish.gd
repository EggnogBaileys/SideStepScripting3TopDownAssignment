extends CharacterBody3D

var players: Array[Node3D]

@export var speed: float = 18.0
@export var max_speed: float = 20.0


func _physics_process(delta):

	players = $PlayerDetection.get_overlapping_bodies()

	if not players.is_empty():
		look_at(players[0].global_position)
		
		velocity = velocity.move_toward(((players[0].position - position).normalized() * max_speed), \
		delta * speed)
		
		move_and_slide()


func _on_player_detection_body_entered(_body):
	pass # Replace with function body.
