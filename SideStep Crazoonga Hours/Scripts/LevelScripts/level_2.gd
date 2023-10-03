extends Node3D

@onready var camTransitions = $Cameras/CameraTransitions
@onready var player = $Crazoonga

#@onready var fish = $Enemies/Fish
#var fishDefeated = false

# incremented whenever the player completes 'level progress', 
# indicated by the designer's choice.
# Here, that will be for advancing camera stages, and triggering the enemy battle.
var currentProgress = 0
# Which camera is currently active.
var currentCam = 1

@export var dialogue: NodePath


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
	elif player.position.z > -46 and currentCam == 3:
		currentCam = 4 
		camTransitions.play("Cam3To4")
	elif player.position.z < -47 and currentCam == 4:
		currentCam = 3
		camTransitions.play("Cam4To3")
		
		
			

