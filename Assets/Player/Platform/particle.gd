extends Node2D


@export var particleMoveSpeed := 700

@export var shoot_direction := 1

func _ready():
	var particleScaleChange = create_tween()
	particleScaleChange.tween_property($Sprite2D, 'scale', Vector2(1,1), 0.2).from(Vector2(0,0))


func _process(delta):
	if shoot_direction == 1:
		position.x += particleMoveSpeed * delta
	else:
		position.x -= particleMoveSpeed * delta
