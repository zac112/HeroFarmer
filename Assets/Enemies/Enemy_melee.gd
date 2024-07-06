extends CharacterBody2D

const SPEED = 300
const GRAVITY = 500
var direction = 1

@export var moving = true

@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight

func _physics_process(delta):
	if moving:
		if ray_cast_right.is_colliding() or ray_cast_left.is_colliding():
			direction *= -1

		velocity.x = direction * SPEED
	velocity.y = GRAVITY

	move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "player_platform":
		print("Player view area entered!")
