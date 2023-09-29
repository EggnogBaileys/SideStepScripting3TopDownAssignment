extends Node3D

signal checkShells

var crazoonga: NodePath



func _on_area_3d_body_entered(_body):
	if Singleton.shellCount < 3:
		Singleton.shellCount += 1
		emit_signal("checkShells")
		print(Singleton.shellCount)
		queue_free()
