extends Node2D

#var particle_scene: PackedScene = load("res://Assets/Player/Platform/particle.tscn")


func _ready():
	pass
	
func _process(delta):
	pass
	
	
"""
func _on_player_platform_particle(pos, direction):
	var particle = particle_scene.instantiate()
	$".".add_child(particle)
	if direction == 1:
		particle.position = pos
		particle.shoot_direction = 1
		print(pos)
	else:
		particle.position = pos
		particle.shoot_direction = 0
		print(pos)
"""
