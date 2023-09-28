extends Node3D



func _on_area_3d_area_entered(area):
	
	if area.name == "CrazoongaArea3D":
		
		Singleton.coinCoint += 1
		print(Singleton.coinCoint)
		queue_free()
