extends Node2D

var particle_scene: PackedScene = load("res://Assets/Player/Platform/particle.tscn")


func _ready():
	pass
	
func _process(delta):
	pass
	
	

func _on_player_platform_particle(pos):
	var particle = particle_scene.instantiate()
	$".".add_child(particle)
	particle.position = pos
	print(pos)
