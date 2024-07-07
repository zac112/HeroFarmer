extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle = $Marker2D
@onready var particle = preload("res://Assets/Player/Platform/particle.tscn")
@onready var farm_scene = preload("res://Assets/Farm/Farm.tscn")
var par
var muzzle_position

const JUMP_SOUND = preload("res://Assets/Audio/029_Decline_09.wav")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


enum State {Idle, Run, Jump, Shoot}
var current_state

var last_dir = 1

var playerHealth := 3
var invincible = false
var can_shoot = true


# TODO dummy var
var doublejump = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	muzzle_position = muzzle.position
	current_state = State.Idle

	
func _process(delta):
	pass


func player_shooting(delta):
	
	var direction = input_movement()
	
	if Input.is_action_just_pressed("Platform_shoot") and can_shoot:
		par = particle.instantiate()
		par.direction = last_dir	
		par.global_position = muzzle.global_position
		get_parent().add_child(par)
		current_state = State.Shoot
		can_shoot = false
		$ShootTimer.start()

		
func player_muzzle_position():
	
	var direction = input_movement()
	
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x

func player_falling(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		

func player_idle(delta):
	if is_on_floor():
		current_state = State.Idle

func player_run(delta):
	
	if !is_on_floor():
		return
	
	var direction = input_movement()
	
	if direction:
		velocity.x = direction * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

		
	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction > 0 else true

func player_jump(delta):
	# Handle jump.
	
	"""
	doublejump power-up works via doublejump variable
	disabled below until powerup works from inventory
	"""
	
	doublejump = false
	if Input.is_action_just_pressed("Platform_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_state = State.Jump
		SfxHandler.play(JUMP_SOUND, get_tree().current_scene)
	elif Input.is_action_just_pressed("Platform_jump") and !is_on_floor() and doublejump:
		velocity.y = JUMP_VELOCITY
		current_state = State.Jump
	
	var dire = Input.get_axis("Platform_left", "Platform_right")
	
	if dire:
		velocity.x = dire * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if dire != 0:
		animated_sprite_2d.flip_h = false if dire > 0 else true
		last_dir = dire

func player_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("idle")
		

func _physics_process(delta):
	print(velocity.y)
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	move_and_slide()
	player_animation()
	move_and_slide()
	player_muzzle_position()
	player_shooting(delta)
	
func input_movement():
	var direction: float = Input.get_axis("Platform_left", "Platform_right")
	return direction
	
	
func take_damage():
	if not invincible:
		playerHealth -= 1
		$AnimatedSprite2D.modulate.a -= 0.33
		print("HEALTH ", playerHealth, " ", $AnimatedSprite2D.modulate.a)
		if playerHealth <= 0:
			print("GAME OVER")
			get_tree().change_scene_to_packed(farm_scene)
		
		invincible = true
		$Invisibility.start()


func _on_invisibility_timeout():
	invincible = false


func _on_shoot_timer_timeout():
	can_shoot = true
