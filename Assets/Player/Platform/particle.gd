extends Node2D

var speed = 750
var shoot_dir = 1
var damage = 10

func _physics_process(delta):
	if shoot_dir == 1:
		position.x += speed * delta
	else:
		position.x -= speed * delta


func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage)
	queue_free()
