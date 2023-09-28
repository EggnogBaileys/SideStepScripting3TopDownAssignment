extends MeshInstance3D

# The hole is gone! Moved to Hole.gd. The lobster doesn't need the hole to survive
# This is way more flexible and maintainable, read Hole.gd for more info

# Read the comment in _on_rock_throw_timer_timeout()
signal throw_rock

var health: int = 3
# Declare variables used every frames in global scope to save performances
# Also give it a type, types are good
var players: Array[Node3D]


# Put underscores before unused arguments
func _process(_delta):
	# $PlayerDetection will only detect the player, Read the comment
	# of _on_lobster_hurtbox_area_entered() for more info
	# Areas can return an array of everything inside of them
	# Note that Static/Rigid/CharacterBodies are bodies, and Areas are areas
	players = $PlayerDetection.get_overlapping_bodies()
	# If the array that can only contain players is not empty,
	# Then the first element is the player
	# No need to set or keep track of any global variables, and you can test
	# the lobster's scene by itself
	if not players.is_empty():
		look_at(players[0].global_position)


# Notice how the function doesn't check who touched it, and only runs whent
# the claw snaps the lobster. The $LobsterHurtbox has its collision mask set
# to 3, which I have named "claw", and the crab's $ClawSwing has its collision
# layer set to 3, "claw" also
# Think of a collision mask as "reading all physics objects that affect this
# layer," and a collision layer as "affecting the layer."
func _on_lobster_hurtbox_area_entered(_area):
	# Use print_debug instead. They say where they come from,
	# and they don't run if you forget to remove them
	# This matters, because print statements are surprisingly costly
	# in terms of resources
	print_debug("Ouch")
	health -= 1
	if health < 1:
		queue_free()


# The lobster shouldn't care if a rock spawns or not,
# since the rocks become children of the lobster's parent
# Use a signal instead, and connect it at the best place
func _on_rock_throw_timer_timeout():
	emit_signal("throw_rock")


# No need to check the body that triggered the singal
# Read the comment on function _on_lobster_hurtbox_area_entered()
func _on_player_detection_body_entered(_body):
	$RockThrowTimer.start()


# Same as above
func _on_player_detection_body_exited(_body):
	$RockThrowTimer.stop()
