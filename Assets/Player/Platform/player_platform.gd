extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D



const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_shoot := true
var inventory = {}

enum State {Idle, Run, Jump}
var current_state

signal particle(pos, direction)


@onready var playerName = %Label

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	current_state = State.Idle
	inventory["gold"] = 1
	inventory["seed"] = 2
	inventory["powerup"] = 3
	
func _process(delta):
	if Input.is_action_just_pressed("Platform_shoot") and can_shoot:
		print("SHOOT", can_shoot)
		if animated_sprite_2d.flip_h == false:
			particle.emit($RightShootMarker.global_position, 1)
		else:
			particle.emit($LeftShootMarker.global_position, 0)
	
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
	if Input.is_action_just_pressed("Platform_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_state = State.Jump
	
	var dire = Input.get_axis("Platform_left", "Platform_right")
	
	if dire:
		velocity.x = dire * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if dire != 0:
		animated_sprite_2d.flip_h = false if dire > 0 else true
	

func player_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("idle")
		

func _physics_process(delta):
	
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	move_and_slide()
	player_animation()
	move_and_slide()
	
func input_movement():
	var direction: float = Input.get_axis("Platform_left", "Platform_right")
	return direction
