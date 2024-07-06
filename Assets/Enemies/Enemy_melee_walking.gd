extends CharacterBody2D

const SPEED = 300
const GRAVITY = 500
var direction = 1

var health = 50

@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_down_left = $RayCastDownLeft
@onready var ray_cast_down_right = $RayCastDownRight

func _physics_process(delta):
	if is_on_floor():
		if ray_cast_right.is_colliding() or ray_cast_left.is_colliding() or not ray_cast_down_left.is_colliding() or not ray_cast_down_right.is_colliding():
			direction *= -1
		velocity.x = direction * SPEED
	else:
		velocity.y = GRAVITY

	move_and_slide()


func hit(damage:int):
	health -= damage
	if health <= 0:
		queue_free()
