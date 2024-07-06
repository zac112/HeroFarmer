extends Node2D

var speed = 750
var direction = Vector2(1,0)
var damage = 10

@export var bullet_particle : PackedScene

func _physics_process(delta):
	move_local_x(direction.x * speed * delta)
	move_local_y(direction.y * speed * delta)

func _on_body_entered(body):
	if body.name == "player_platform":
		print("Hit",body)
		var particle = bullet_particle.instantiate()
		particle.emitting = true
		particle.position = position
		get_parent().add_child(particle)
		if body.has_method("hit"):
			body.hit(damage)
		queue_free()

func _ready():
	$BulletAudio.play()
