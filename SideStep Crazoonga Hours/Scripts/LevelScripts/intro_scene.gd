extends Node3D

@onready var camTransitions = $CameraTransitions
@onready var player = $Crazoonga

# incremented whenever the player completes 'level progress', 
# indicated by the designer's choice.
# Here, that will be for advancing camera stages, and triggering the enemy battle.
var currentProgress = 0
# Which camera is currently active.
var currentCam = 1

func _process(_delta):
	
	if currentProgress < 2:
		if player.position.z < 15 and currentCam == 1:
			currentCam = 2
			camTransitions.play("Cam1To2")
		elif player.position.z > 16 and currentCam == 2:
			currentCam = 1
			camTransitions.play("Cam2To1")
			
	if currentProgress == 1:
		if player.position.z < -5 and currentCam == 2:
			currentCam = 3 
			camTransitions.play("Cam2To3")
			player.in_cutscene = true
			
			
			

		
	

func firstShellPicked():
	print("something")
	currentProgress = 1 
	player.in_cutscene = true

