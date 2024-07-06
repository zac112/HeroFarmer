extends Node2D

var speed = 750
var shoot_dir = 1

func _physics_process(delta):
	if shoot_dir == 1:
		position.x += speed * delta
	else:
		position.x -= speed * delta


func _on_body_entered(body):
	queue_free()
