extends Node3D

@onready var camTransitions = $CameraTransitions
@onready var player = $Crazoonga

@onready var fish = $Enemies/Fish

# incremented whenever the player completes 'level progress', 
# indicated by the designer's choice.
# Here, that will be for advancing camera stages, and triggering the enemy battle.
var currentProgress = 0
# Which camera is currently active.
var currentCam = 1

@export var dialogue: NodePath

func _ready():
	$"Cameras/Camera2/Tutorial Text2".hide()

func _process(_delta):
	
	if currentProgress < 2:
		if player.position.z < 15 and currentCam == 1:
			currentCam = 2
			if currentProgress == 0:
				$"Cameras/Camera2/Tutorial Text2".show()
			$"Cameras/Camera1/Tutorial Text".hide()
			$"Cameras/Camera1/Tutorial Title".hide()
			camTransitions.play("Cam1To2")
		elif player.position.z > 16 and currentCam == 2:
			currentCam = 1
			$"Cameras/Camera2/Tutorial Text2".hide()
			camTransitions.play("Cam2To1")
			
	if currentProgress == 1:
		if player.position.z < -5 and currentCam == 2:
			currentCam = 3 
			$"Cameras/Camera2/Tutorial Text2".hide()
			fish.show()
			camTransitions.play("Cam2To3")
			player.in_cutscene = true
			await get_tree().create_timer(0.75).timeout
			camTransitions.play("Cam3Zoom")
			await get_tree().create_timer(5.0).timeout
			$"Cameras/Fishy name".hide()
			currentProgress = 2
			camTransitions.play("Cam3To4")
			player.in_cutscene = false



func firstShellPicked():
	currentProgress = 1 

