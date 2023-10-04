extends Node3D

@onready var camTransitions = $Cameras/CameraTransitions
@onready var player = $Crazoonga

var isLevelDone = false
var fish3spawned: bool = false

#@onready var fish = $Enemies/Fish
#var fishDefeated = false

# incremented whenever the player completes 'level progress', 
# indicated by the designer's choice.
# Here, that will be for advancing camera stages, and triggering the enemy battle.
var currentProgress = 0
# Which camera is currently active.
var currentCam = 1

@export var dialogue: NodePath


func _ready():
	$Fish3.position.z = -2

func _process(_delta):

	if player.position.z > -90 and currentCam == 1:
		currentCam = 2
		camTransitions.play("Cam1To2")
	elif player.position.z < -91 and currentCam == 2:
		currentCam = 1
		camTransitions.play("Cam2To1")

	if player.position.x > 5 and currentCam < 3:
		currentCam = 3
		camTransitions.play("Cam2To3")
	elif player.position.x < 5 and currentCam == 3:
		currentCam = 2
		camTransitions.play("Cam3To2")
		if player.hasMatch and !fish3spawned:
			fish3spawned = true
			$Fish3.position.z = -78.5
	elif player.position.z > -46 and currentCam == 3:
		currentCam = 4 
		camTransitions.play("Cam3To4")
	elif player.position.z < -47 and currentCam == 4:
		currentCam = 3
		camTransitions.play("Cam4To3")

	if player.position.z > -30 and not isLevelDone:
		isLevelDone = true
		$EndScreenUI.show()
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/level_3.tscn")

	if player.shell_count < 0:
		$YouDied.show()

