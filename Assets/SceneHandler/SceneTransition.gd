extends Area2D

@export var targetScene : String

func _on_body_entered(body):
	SceneHandler.loadScene(targetScene)
