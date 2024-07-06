extends CharacterBody2D

const SPEED = 300.0
var direction = 1

func _physics_process(delta):

	if position.x > 1000:
		direction = -1
	velocity.x = direction * SPEED
	if position.x < 0:
		direction = 1
	velocity.x = direction * SPEED

	move_and_slide()
