extends CharacterBody2D

const OOF = preload("res://Assets/Audio/01._damage_grunt_male.wav")

const SPEED = 250
const GRAVITY = 500
var direction = 1

@export var moving = true
@export var shooting = false
var player = null
var colliding = false
var can_shoot = true

var health = 50

@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_down_left = $RayCastDownLeft
@onready var ray_cast_down_right = $RayCastDownRight

# Shooting
@onready var muzzle = $Marker2D
@onready var particle = preload("res://Assets/Enemies/particle_enemy.tscn")
var par
var muzzle_position

func _ready():
	muzzle_position = muzzle.position

func _physics_process(delta):
	if shooting and can_shoot:
		can_shoot = false
		$ParticleCooldown.start()
		
		enemy_muzzle_position()
		enemy_shooting(player)

	if moving and is_on_floor():
		if ray_cast_left.is_colliding() or not ray_cast_down_left.is_colliding():
			direction = 1
		if ray_cast_right.is_colliding() or not ray_cast_down_right.is_colliding():
			direction = -1

		velocity.x = direction * SPEED

	velocity.y = GRAVITY

	move_and_slide()
	
	# Does damage if collides with player
	if colliding:
		player.take_damage()


func _on_player_detection_body_entered(body):
	if body.name == "player_platform":
		player = body
		shooting = true
	
		velocity.x = 0
		moving = false


func _on_player_detection_body_exited(body):
	if body.name == "player_platform":
		shooting = false
	
		moving = true

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

func enemy_shooting(player):
	if player.position.x - position.x > 0:
		direction = 1
	elif player.position.x - position.x < 0:
		direction = -1

	par = particle.instantiate()
	par.direction = direction
	par.global_position = muzzle.global_position
	get_parent().add_child(par)

func enemy_muzzle_position():
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x


func _on_particle_cooldown_timeout():
	can_shoot = true
