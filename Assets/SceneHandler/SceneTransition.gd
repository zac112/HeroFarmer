extends Area2D

var levels = ["res://Assets/Farm/Farm.tscn",
"res://Assets/Platform/Level1/level_1.1.tscn",
"res://Assets/Platform/Boss/level_final.tscn"]

@export_range(0,3) var targetScene : int

func _on_body_entered(body):
	SceneHandler.loadScene(levels[targetScene])
