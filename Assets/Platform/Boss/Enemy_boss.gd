extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()
var waypoints
var player 
var timer : Timer
var bulletTimer
var hits = 0

@export var trigger : Area2D
@onready var particle = preload("res://Assets/Platform/Boss/particle_boss.tscn")


func _ready():
	$Sprite.play("vendor")
	player = $"../player_platform"
	waypoints = get_parent().find_children("Waypoint*")
	
	
func chooseAttack():
	while true:
		var attack = [targeted, spiral][rng.randi_range(0,1)]
		var waypoint = waypoints[rng.randi_range(0,len(waypoints)-1)]
		
		global_position = waypoint.global_position
		
		await attack.call()
		await get_tree().create_timer(1).timeout
		
	
func shoot(dir):	
	var par = particle.instantiate()
	par.global_position = global_position
	par.direction = dir
	get_parent().add_child(par)
		
func spiral():
	$Sprite.play("front")
	for i in range(30):
		await get_tree().create_timer(0.2).timeout		
		shoot(Vector2(cos(i/TAU),sin(i/TAU)))
		shoot(Vector2(cos(i/TAU+PI),sin(i/TAU+PI)))
	
func targeted():
	$Sprite.play("front")
	for i in range(5):
		await get_tree().create_timer(0.2).timeout
		shoot(global_position.direction_to(player.global_position))
	
func hit(damage):
	print("final hits ",hits)
	hits += damage
	if hits >= 3:
		SceneHandler.loadScene("res://Assets/TheEnd/TheEnd.tscn")
	
func _physics_process(delta):
	pass
	


func _on_start_boss_body_entered(body):
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2
	timer.one_shot = true
	timer.start()
	timer.connect("timeout",chooseAttack)
	$Sprite.play("left")
	global_position = waypoints[2].global_position
	trigger.queue_free()
