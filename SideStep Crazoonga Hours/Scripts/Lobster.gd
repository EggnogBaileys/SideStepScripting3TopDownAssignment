extends MeshInstance3D

@onready var detection = $"Detection Radius"
var inDetection = false

@onready var crazoonga = get_parent().get_parent().get_node("Crazoonga")

var health = 3



func _process(delta):
	
	if inDetection:
		look_at(crazoonga.position)





func _on_detection_radius_area_entered(area):
	if area.name == "CrazoongaArea3D":
		inDetection = true 

func _on_detection_radius_area_exited(area):
	if area.name == "CrazoongaArea3D":
		inDetection = false


func _on_lobster_hurtbox_area_entered(area):
	if area.name == "ClawSwing":
		print("Ouch")
		health -= 1
		
		if health < 1:
			queue_free()
		
