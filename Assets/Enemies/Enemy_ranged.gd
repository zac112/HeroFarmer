extends CharacterBody2D

const OOF = preload("res://Assets/Audio/01._damage_grunt_male.wav")

const SPEED = 150
const GRAVITY = 500
var direction = 1
const FLEE_SPEED = 50

@export var moving = true
@export var shooting = false
var player = null
var colliding = false # Melee only
var can_shoot = true
var flee = false

var health = 30

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
		if not flee:
			if ray_cast_left.is_colliding() or not ray_cast_down_left.is_colliding():
				direction = 1
			elif ray_cast_right.is_colliding() or not ray_cast_down_right.is_colliding():
				direction = -1
			
		else:
			if player.position.x - position.x > 0:
				direction = -1
			elif player.position.x - position.x < 0:
				direction = 1

		velocity.x = direction * SPEED
	else:
		velocity.x = 0
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "player_platform":
		player = body
		shooting = true
		moving = false


func _on_player_detection_body_exited(body):
	if body.name == "player_platform":
		shooting = false
		moving = true


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
	if player.position.x - position.x > 0:
		muzzle.position.x = muzzle_position.x
	elif player.position.x - position.x < 0:
		muzzle.position.x = -muzzle_position.x
		


func _on_particle_cooldown_timeout():
	can_shoot = true


func _on_flee_zone_body_entered(body):
	if body.name == "player_platform":
		flee = true
		moving = true


func _on_flee_zone_body_exited(body):
	if body.name == "player_platform":
		flee = false
		moving = false
