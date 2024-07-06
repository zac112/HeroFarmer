extends Node2D

var cloud = preload("res://Assets/Farm/Clouds/Cloud.tscn")
var rng = RandomNumberGenerator.new()
var timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.connect("timeout", spawnCloud)

	timer.start()
	

func spawnCloud():
	print("CLOUD")
	var y = rng.randf_range(0,600)-300
	var c : Node2D= cloud.instantiate()
	var scale = rng.randf_range(3,9)
	c.scale = Vector2(scale,scale)
	c.position.x = -670
	c.position.y = y
	add_child(c)
	timer.wait_time = rng.randi_range(6,15)
