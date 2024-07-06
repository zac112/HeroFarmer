extends Node2D

var speed = 750
var direction = 1
var damage = 10

@export var bullet_particle : PackedScene

func _physics_process(delta):
	move_local_x(direction * speed * delta)

func _on_body_entered(body):
	var particle = bullet_particle.instantiate()
	particle.emitting = true
	particle.position = position
	get_parent().add_child(particle)
	if body.has_method("hit"):
		body.hit(damage)
	queue_free()
