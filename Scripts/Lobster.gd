extends MeshInstance3D

@onready var detection = $"Detection Radius"
var inDetection = false

@onready var crazoonga = get_parent().get_parent().get_node("Crazoonga")

@onready var rockScene = preload("res://Scenes/rock.tscn")
@onready var thisScene = get_parent().get_parent()
var rock


var health = 3



func _process(_delta):
	
	if inDetection:
		look_at(crazoonga.position)





func _on_detection_radius_area_entered(area):
	if area.name == "CrazoongaArea3D":
		$RockThrowTimer.start()
		inDetection = true 

func _on_detection_radius_area_exited(area):
	if area.name == "CrazoongaArea3D":
		$RockThrowTimer.stop()
		inDetection = false


func _on_lobster_hurtbox_area_entered(area):
	if area.name == "ClawSwing":
		print("Ouch")
		health -= 1
		
		if health < 1:
			queue_free()
		


func _on_rock_throw_timer_timeout():
	$RockThrowTimer.start()
	ThrowRock()
	
func ThrowRock():
	rock = rockScene.instantiate()
	rock.position = position
	thisScene.add_child(rock)




