extends Node3D


func _on_button_pressed():
	Singleton.enemiesDefeated = 0
	Singleton.crabDeaths = 0
	get_tree().change_scene_to_file("res://Scenes/Levels/intro_scene.tscn")
