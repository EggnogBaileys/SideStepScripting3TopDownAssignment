extends Node3D

@onready var levelProgress = get_parent().get_parent()

func picked_up():
	queue_free()

func increment_progress():
	levelProgress.firstShellPicked()
	queue_free()
	
