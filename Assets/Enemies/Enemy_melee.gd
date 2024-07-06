extends CharacterBody2D

const SPEED = 300
const GRAVITY = 500
var direction = 1

@export var moving = true

@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_down_left = $RayCastDownLeft
@onready var ray_cast_down_right = $RayCastDownRight

func _physics_process(delta):
	if moving and is_on_floor():
		if ray_cast_right.is_colliding() or ray_cast_left.is_colliding() or not ray_cast_down_left.is_colliding() or not ray_cast_down_right.is_colliding():
			direction *= -1

		velocity.x = direction * SPEED
	else:
		velocity.y = GRAVITY

	move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "player_platform":
		print("Player view area entered!")
