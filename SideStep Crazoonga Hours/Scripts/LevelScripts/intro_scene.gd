extends Node3D

@onready var camTransitions = $CameraTransitions
@onready var player = $Crazoonga

@onready var fish = $Enemies/Fish
var fishDefeated = false

# incremented whenever the player completes 'level progress', 
# indicated by the designer's choice.
# Here, that will be for advancing camera stages, and triggering the enemy battle.
var currentProgress = 0
# Which camera is currently active.
var currentCam = 1

@export var dialogue: NodePath

func _ready():
	$"UI/Tutorial Text2".hide()

func _process(_delta):
	
	if fish == null and fishDefeated == false:
		fishDefeated = true
		Singleton.enemiesDefeated += 1
		camTransitions.play("MusicFadeout")
		$"Cameras/Camera4/You Win".show()
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/level_2.tscn")
		# Load next stage
	
	if currentProgress < 2:
		if player.position.z < 17 and currentCam == 1:
			currentCam = 2
			if currentProgress == 0:
				$"UI/Tutorial Text2".show()
			$"UI/Tutorial Text".hide()
			$"UI/Tutorial Title".hide()
			camTransitions.play("Cam1To2")
		elif player.position.z > 18 and currentCam == 2:
			currentCam = 1
			$"UI/Tutorial Text2".hide()
			camTransitions.play("Cam2To1")
			
	if currentProgress == 1:
		if player.position.z < -5 and currentCam == 2:
			currentCam = 3 
			$"UI/Tutorial Text2".hide()
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

	if player.shell_count < 0:
		$YouDied.show()

func firstShellPicked():
	currentProgress = 1 

