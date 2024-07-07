extends CharacterBody2D

const PLAYER_HURT = preload("res://Assets/Audio/01._damage_grunt_male.wav")

const SPEED = 150
const GRAVITY = 500
var direction = 1

@export var moving = true
@export var following = false
var player = null
var colliding = false

var health = 50

var rng = RandomNumberGenerator.new()
@export var seed_item : PackedScene
var carrot_seed = load("res://Assets/Farm/Plot/Plant/Seeds/Carrot_seed.tres")

@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_down_left = $RayCastDownLeft
@onready var ray_cast_down_right = $RayCastDownRight

var can_follow = true

func _physics_process(delta):
	if !can_follow:
		velocity.x = move_toward(velocity.x, 0, SPEED)
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

	move_and_slide()
	
	# Does damage if collides with player
	if colliding:
		player.take_damage()


func _on_player_detection_body_entered(body):
	if $SoundCooldown.is_stopped():
		$SoundCooldown.start()
		
	if body.name == "player_platform":
		player = body
		following = true

func _on_sound_cooldown_timeout():
	$EnemyProximitySound.play()
	$SoundCooldown.start()

func _on_player_detection_body_exited(body):
	if body.name == "player_platform":
		following = false

func _on_player_collision_body_entered(body):
	if body.has_method("take_damage"):
		SfxHandler.play(PLAYER_HURT, get_tree().current_scene)
		body.take_damage()
		can_follow = false
		velocity.x = direction * -1 * 1500
		velocity.y = -200
		$FollowCooldown.start()
		move_and_slide()


		colliding = true


func _on_player_collision_body_exited(body):
	if body.has_method("take_damage"):
		colliding = false


func hit(damage:int):
	health -= damage
	if health <= 0:
		var drop = rng.randi_range(1,2)
		if drop == 2:
			var seed = seed_item.instantiate()
			seed.position = position
			get_parent().add_child(seed)
			seed.change_sprite(carrot_seed.seed_sprite)
			seed.seed = carrot_seed
			print("Get seed")
			
		queue_free()



func _on_follow_cooldown_timeout():
	can_follow = true
