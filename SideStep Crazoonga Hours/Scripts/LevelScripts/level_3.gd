extends Node3D

@onready var player = $Crazoonga

var isLevelDone = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if player.shell_count < 0:
		$YouDied.show()
