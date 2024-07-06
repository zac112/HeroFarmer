extends Node2D


@export var particleMoveSpeed := 500

func _ready():
	var particleScaleChange = create_tween()
	particleScaleChange.tween_property($Sprite2D, 'scale', Vector2(1,1), 0.2).from(Vector2(0,0))


func _process(delta):
	position.x += particleMoveSpeed * delta
