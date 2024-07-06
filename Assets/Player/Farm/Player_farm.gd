extends CharacterBody2D


const SPEED = 300.0

@onready var anim_player =  $Sprite2D

func _physics_process(_delta):
	
	# Horizontal movement input
	var horizontal = Input.get_axis("Farm_left", "Farm_right")
	# Vertical movement input
	var vertical = Input.get_axis("Farm_up", "Farm_down")
	
	if horizontal + vertical != 0:
		anim_player.play("default")
	else:
		anim_player.stop()
		
	if horizontal:
		anim_player.flip_h = false if horizontal > 0 else true
		velocity.x = horizontal * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if vertical:
		velocity.y = vertical * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
