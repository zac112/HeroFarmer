extends CharacterBody2D

const OOF = preload("res://Assets/Audio/01._damage_grunt_male.wav")

const SPEED = 250
const GRAVITY = 500
var direction = 1

@export var moving = true
@export var following = false
var player = null
var colliding = false

var health = 50


@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_down_left = $RayCastDownLeft
@onready var ray_cast_down_right = $RayCastDownRight

func _physics_process(delta):
	if following:
		if player.position.x - position.x > 0:
			direction = 1
		elif player.position.x - position.x < 0:
			direction = -1

		velocity.x = direction * SPEED
	elif moving and is_on_floor():
		if ray_cast_right.is_colliding() or ray_cast_left.is_colliding() or not ray_cast_down_left.is_colliding() or not ray_cast_down_right.is_colliding():
			direction *= -1

		velocity.x = direction * SPEED

	velocity.y = GRAVITY

	move_and_slide()
	
	# Does damage if collides with player
	if colliding:
		player.take_damage()


func _on_player_detection_body_entered(body):
	if body.name == "player_platform":
		player = body
		following = true


func _on_player_detection_body_exited(body):
	if body.name == "player_platform":
		following = false

func _on_player_collision_body_entered(body):
	if body.has_method("take_damage"):
		SfxHandler.play(OOF, get_tree().current_scene)
		body.take_damage()


		colliding = true


func _on_player_collision_body_exited(body):
	if body.has_method("take_damage"):
		colliding = false


func hit(damage:int):
	health -= damage
	if health <= 0:
		queue_free()

