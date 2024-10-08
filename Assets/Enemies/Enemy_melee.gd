extends CharacterBody2D

const PLAYER_HURT = preload("res://Assets/Audio/1yell1.wav")
@export var death_particles : PackedScene

@export var SPEED = 150
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

# Raycast
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_down_left = $RayCastDownLeft
@onready var ray_cast_down_right = $RayCastDownRight

# Melee only
@export var following = false
var colliding = false
var can_follow = true

func _physics_process(delta):
	if $FollowCooldown.time_left < 0.8 and !can_follow and is_on_floor():
		velocity.y = -100
	elif !can_follow:
		velocity.x = move_toward(velocity.x, 0, 250)
	elif following:
		if player.position.x - position.x > 0:
			direction = 1
		elif player.position.x - position.x < 0:
			direction = -1

		velocity.x = direction * SPEED
	elif moving and is_on_floor():
		if ray_cast_right.is_colliding() or ray_cast_left.is_colliding() or not ray_cast_down_left.is_colliding() or not ray_cast_down_right.is_colliding():
			direction *= -1

		velocity.x = direction * SPEED	

	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
	if direction > 0:
		$AnimatedSprite2D.flip_h = true
	elif direction < 0:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()
	
	# Does damage if collides with player
	if colliding:
		player.take_damage()


func _on_player_detection_body_entered(body):
	if body.name == "player_platform":
		player = body
		following = true

	if $SoundCooldown.is_stopped():
		$SoundCooldown.start()

func _on_player_detection_body_exited(body):
	if body.name == "player_platform":
		following = false

func _on_player_collision_body_entered(body):
	if body.has_method("take_damage"):
		SfxHandler.play(PLAYER_HURT, get_tree().current_scene)
		colliding = true
		can_follow = false
		velocity.x = direction * -1 * 1500
		velocity.y = -200
		$FollowCooldown.start()
		move_and_slide()


func _on_player_collision_body_exited(body):
	if body.has_method("take_damage"):
		colliding = false


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


func _on_follow_cooldown_timeout():
	can_follow = true


func _on_sound_cooldown_timeout():
	$EnemyProximitySound.play()
	$SoundCooldown.start()
