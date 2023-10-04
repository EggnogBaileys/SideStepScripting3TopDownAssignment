extends CharacterBody3D

@export var rockSpeed = 25

@onready var player = get_parent().get_node("Crazoonga")
@onready var lobster = get_parent().get_node("Hole/Lobster")

var throwDirection: Vector3 

func _ready():
	throwDirection = player.position

func _process(delta):
	velocity = (throwDirection - position).normalized()*rockSpeed
	position += velocity * delta





func _on_timer_timeout():
	queue_free()
