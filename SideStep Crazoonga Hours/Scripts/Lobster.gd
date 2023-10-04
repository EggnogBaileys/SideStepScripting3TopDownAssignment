extends MeshInstance3D


signal throw_rock

var health: int = 9

var players: Array[Node3D]



func _process(_delta):
	# Areas can return an array of everything inside of them
	# Note that Static/Rigid/CharacterBodies are bodies, and Areas are areas
	players = $PlayerDetection.get_overlapping_bodies()
	# If the array that can only contain players is not empty,
	# Then the first element is the player
	if not players.is_empty():
		look_at(players[0].global_position)


func _on_lobster_hurtbox_area_entered(_area):
	print_debug("Ouch")
	health -= 1
	$Hit.play()
	if health == 6:
		$Movement.play("phase1change")
	if health == 3:
		$Movement.play("phase3")
	if health < 1:
		queue_free()



func _on_rock_throw_timer_timeout():
	$Lobster_Anims/AnimationPlayer.play("Lobster Attack")
	emit_signal("throw_rock")



func _on_player_detection_body_entered(_body):
	$RockThrowTimer.start()


func _on_player_detection_body_exited(_body):
	$RockThrowTimer.stop()
