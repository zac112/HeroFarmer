extends Node2D

var particle_scene: PackedScene = load("res://Assets/Player/Platform/particle.tscn")


func _ready():
	pass
	
func _process(delta):
	pass
	
	
func _on_player_shoot_particle(pos):
	print(pos)
