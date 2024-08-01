extends Node2D


@export var speed = 300
@export var lifetime_sec = 3.0

# instantiate velocity and acceleration as zeroes
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var direction = Vector2(1,0)


func _ready():
	var timer = get_tree().create_timer(3)
	timer.connect("timeout", lifetime_end)
	var missileScaleChange = create_tween()
	missileScaleChange.tween_property($Animation, 'scale', Vector2(2,2), 0.2).from(Vector2(0,0))

	
func _physics_process(_delta):
	velocity += acceleration * _delta
	move_local_x(direction.x * speed * _delta)
	move_local_y(direction.y * speed * _delta)
	
func lifetime_end():
	queue_free()

func _on_body_entered(body):
	pass # Replace with function body.
