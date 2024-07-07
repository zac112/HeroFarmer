extends Node2D

const BULLET = preload("res://Assets/Audio/Voicy_Spider-Man web shoot sound effect.wav")

var speed = 500
var direction = 1
var damage = 10

@export var bullet_particle_enemy : PackedScene

func _physics_process(delta):
	move_local_x(direction * speed * delta)

func _on_body_entered(body):
	var particle = bullet_particle_enemy.instantiate()
	particle.emitting = true
	particle.position = position
	get_parent().add_child(particle)
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()

func _ready():
	SfxHandler.play(BULLET, get_tree().current_scene)
