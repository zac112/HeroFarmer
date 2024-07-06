extends Node2D

var speed = 750
var direction = 1
var damage = 10

func _physics_process(delta):
	move_local_x(direction * speed * delta)


func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage)
	queue_free()
