extends CharacterBody2D


@onready var sprite_2d = $Sprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_shoot := true
var inventory = {}

enum State {Idle, Run, Jump}
var current_state

signal particle(pos)


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
		particle.emit($RightShootMarker.global_position)
	

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("Platform_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_state = State.Jump

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Platform_left", "Platform_right")
	if direction:
		velocity.x = direction * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction != 0:
		current_state = State.Run
		sprite_2d.flip_h = false if direction > 0 else true


	move_and_slide()
