extends CharacterBody2D

const OOF = preload("res://Assets/Audio/1yell1.wav")
const death_sound = preload("res://Assets/Audio/1yell1.wav")
@export var death_particles : PackedScene

@export var speed = 75
const GRAVITY = 500
@export var health = 50
var direction = 1

@export var moving = true
var player = null

# Seed spawning
var rng = RandomNumberGenerator.new()
@export var seed_item : PackedScene
@export var seed_drop_rate = 4
var carrot_seed = load("res://Assets/Farm/Plot/Plant/Seeds/Carrot_seed.tres")
var turnip_seed = load("res://Assets/Farm/Plot/Plant/Seeds/Turnip_seed.tres")
var pumpkin_seed = load("res://Assets/Farm/Plot/Plant/Seeds/Pumpkin_seed.tres")

# Raycasts
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_down_left = $RayCastDownLeft
@onready var ray_cast_down_right = $RayCastDownRight

# Ranged only
@export var shooting = false
var can_shoot = true
var flee = false

# For shooting
@onready var muzzle = $Marker2D
@onready var particle = preload("res://Assets/Enemies/particle_enemy.tscn")
var par
var muzzle_position
#

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

		velocity.x = direction * speed
	else:
		velocity.x = 0
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	if direction > 0:
		$AnimatedSprite2D.flip_h = true
	elif direction < 0:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "player_platform":
		player = body
		shooting = true
		moving = false

	if $SoundCooldown.is_stopped():
		$SoundCooldown.start()


func _on_player_detection_body_exited(body):
	if body.name == "player_platform":
		shooting = false
		moving = true


func hit(damage:int):
	health -= damage
	if health <= 0:
		if seed_drop_rate == 1:
			var seed = seed_item.instantiate()
			seed.position = position
			get_parent().add_child(seed)
			seed.change_sprite(carrot_seed.seed_sprite)
			seed.seed = carrot_seed
		else:
			var drop = rng.randi_range(1,seed_drop_rate)
			if drop == 1:
				var drop_seed = rng.randi_range(1, 3)
				var seed = seed_item.instantiate()
				seed.position = position
				get_parent().add_child(seed)
				if drop_seed == 1:
					seed.change_sprite(carrot_seed.seed_sprite)
					seed.seed = carrot_seed
				elif drop_seed == 2:
					seed.change_sprite(turnip_seed.seed_sprite)
					seed.seed = turnip_seed
				elif drop_seed == 3:
					seed.change_sprite(pumpkin_seed.seed_sprite)
					seed.seed = pumpkin_seed

		# Death particles
		var deathp = death_particles.instantiate()
		deathp.position = position
		deathp.emitting = true
		get_parent().add_child(deathp)

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


func _on_sound_cooldown_timeout():
	$EnemyProximitySound.play()
	$SoundCooldown.start()
