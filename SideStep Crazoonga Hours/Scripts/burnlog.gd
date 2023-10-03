extends Node3D

@onready var animationPlayer = $AnimationPlayer

func _on_log_burn_area_area_entered(area):
	print(area.name)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Burn":
		queue_free()
