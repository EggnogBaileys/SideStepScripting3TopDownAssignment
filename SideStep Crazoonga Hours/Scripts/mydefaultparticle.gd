@tool
extends StandardMaterial3D
class_name MyDefaultParticle3D

func _init():
	billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	billboard_keep_scale = true
	transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	emission_enabled = true
	emission_energy_multiplier = 1.3
	var default_particle = load("res://Images/whitegradient.png")
	albedo_texture = default_particle
	vertex_color_use_as_albedo = true
	albedo_color = Color.DEEP_PINK
	

