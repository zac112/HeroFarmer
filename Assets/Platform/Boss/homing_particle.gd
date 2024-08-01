
#TODO
#comments

extends Node2D


@export var speed = 350
@export var steer_force = 50.0
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null
var direction = Vector2(0,0)



func _ready():
	var timer = get_tree().create_timer(3)
	timer.connect("timeout", lifetime_end)
	var missileScaleChange = create_tween()
	missileScaleChange.tween_property($Animation, 'scale', Vector2(2,2), 0.2).from(Vector2(0,0))

func start(global_position, player):
	global_position = global_position
	direction = global_position.direction_to(player.global_position)
	rotation += randf_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = player

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.global_position - global_position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.limit_length(speed)
	rotation = velocity.angle()
	global_position += velocity * delta

func lifetime_end():
	queue_free()

func _on_body_entered(body):
	if body.name == "player_platform":
		if body.has_method("take_damage"):
			body.take_damage()
	lifetime_end()
