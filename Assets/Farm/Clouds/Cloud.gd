extends Sprite2D

var rng = RandomNumberGenerator.new()

func _process(delta):
	position.x += rng.randf_range(0.5,3)
