extends Node3D

@onready var player = $Crazoonga

var isLevelDone = false

@onready var lobster = $Hole/Lobster
var lobsterDefeated = false


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	
	if lobster == null and lobsterDefeated == false:
		lobsterDefeated = true
		Singleton.enemiesDefeated += 1
		$Boss.stop()
		$EndScreenUI.show()
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/end_screen.tscn")
		# Load next stage

	if player.shell_count < 0:
		$YouDied.show()
