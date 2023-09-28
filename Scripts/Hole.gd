# A Marker3D is just a Node3D that's more visible in the editor
extends Marker3D

@export var rock_scene = preload("res://Environment/Rocks/rock.tscn")

func _ready():
	# Get all the lobsters loaded in the scene and tell them to throw rocks here
	# spawn_rock() will run when they emit the signal "throw_rock"
	# This method uses groups, very useful: https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
	for lobster in get_tree().get_nodes_in_group("lobsters"):
		# Signals have changed since Godot 3, here are some resources:
		# https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-method-connect
		# https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html#connecting-a-signal-via-code
		lobster.throw_rock.connect(spawn_rock)


func spawn_rock():
	var rock = rock_scene.instantiate()
	rock.position = global_position
	# Be careful with get_parent()
	get_parent().add_child(rock)
