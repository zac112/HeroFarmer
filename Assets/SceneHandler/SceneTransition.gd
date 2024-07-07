extends Area2D

var levels = ["res://Assets/Farm/Farm.tscn",
"res://Assets/Platform/Tutorial/level_tutorial.tscn",
"res://Assets/Platform/Level1/level_1.1.tscn",
"res://Assets/Platform/Boss/level_final.tscn"]

@export var levelEnd : bool

func _on_body_entered(body):
	if levelEnd: 
		FarmData.level += 1
		SceneHandler.loadScene(levels[0])
	else:
		SceneHandler.loadScene(levels[FarmData.level])
	

