extends CharacterBody2D


const SPEED = 300.0

@export var carrot_seed : Seed
var seed_inventory = []

func _ready():
	seed_inventory.append(carrot_seed)

func _physics_process(_delta):
	
	# Horizontal movement input
	var horizontal = Input.get_axis("Farm_left", "Farm_right")
	# Vertical movement input
	var vertical = Input.get_axis("Farm_up", "Farm_down")
	
	if horizontal:
		velocity.x = horizontal * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if vertical:
		velocity.y = vertical * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func get_seeds():
	return seed_inventory
