extends CharacterBody2D

const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# changed to var, needed for raining blood
var SPEED = 300.0
# random number generator
var rng = RandomNumberGenerator.new()
# list of waypoints on the map, populated by func _ready()
var waypoints
# human player variable
var player 
# timer for cutscene
var timer : Timer
# hits taken by boss
var hits = 0
# hit indicator
var is_hit = false
# phase counter
var phase = 0
# cutscene trigger
@export var trigger : Area2D
# "fireball" particles
@onready var particle = preload("res://Assets/Platform/Boss/particle.tscn")
@onready var homing_particle = preload("res://Assets/Platform/Boss/homing_particle.tscn")
@onready var dialogue = preload("res://Assets/Platform/Boss/boss_dialogue.tscn")


func _ready():
	"""
	Run when instantiating the object:
		* Chooses vendor sprite to show
		* player variable is set to human player file
		* waypoints is populated from "level_final.tscn" as a parent
	"""
	$Sprite.play("vendor")
	player = $"../player_platform"
	waypoints = get_parent().find_children("Waypoint*")
	
	
func chooseAttack():
	"""
	Choosing the attack for boss, loop that runs until game ends.
	If clause determines the attack with phase variable. Awaits for attack to complete
	
		Variables:
			* attack (func): attack to be made randomly from a list of attacks
			* waypoint (Node2D): position to be chosen for boss' global position
			* global_position: position of boss
			* phase (int): phase of the bossfight
	
	aaa
	"""
	var attacks = [targeted, spiral, raining, homing_missile]
	var waypoint = waypoints[rng.randi_range(0,len(waypoints)-1)]
	var attack = attacks[0]
	
	while true:
		if phase == 1:
			attack = attacks[2]
			waypoint = waypoints[4]
		elif phase == 2:
			attack = attacks[rng.randi_range(0,3)]
			if attack == raining:
				waypoint = waypoints[4]
			else:
				waypoint = waypoints[rng.randi_range(0,len(waypoints)-1)]
		elif phase == 3:
			attack = attacks[rng.randi_range(0,3)]
			if attack == raining:
				waypoint = waypoints[4]
			else:
				waypoint = waypoints[rng.randi_range(0,len(waypoints)-1)]
		global_position = waypoint.global_position
		
		await attack.call()
		await get_tree().create_timer(1).timeout
		
	
func shoot(dir):
	"""
	Shooting mechanism. Instantiates particle scene, sets it position and direction, adds to parent scene
	
		parameters:
			* dir (Vector2D): direction to where the particle is going to be launched
		
		variables:
			* par (PackedScene): actual particle object
	"""
	var par = particle.instantiate()
	par.global_position = global_position
	par.direction = dir
	get_parent().add_child(par)

func homing():
	"""
	Homing missile mechanism. Instantiates particle scene, sets it position and direction, adds to parent scene
	
		variables:
			* homing (PackedScene): actual particle object
	"""
	var homing = homing_particle.instantiate()
	get_parent().add_child(homing)

func homing_missile():
	"""
	Shoots 1 homing particle that seeks player
	Selects sprite as frontfacing boss.
	Creates timer and awaits it to complete for shooting speed
	Calls homing() function
	"""
	$Sprite.play("front")
	homing()
	await get_tree().create_timer(2).timeout


func spiral():
	"""
	Shoots 2 particles at a time in a spiral formation.
	Selects sprite as frontfacing boss.
	Creates timer and awaits it to complete for shooting speed
	Calls shoot() function
	
		variables:
			* i (int): shooting times per attack
	"""
	$Sprite.play("front")
	for i in range(30):
		if is_hit:
			is_hit = false
			return
		i = i*2
		await get_tree().create_timer(0.2).timeout
		shoot(Vector2(cos(i/TAU),sin(i/TAU)))
		shoot(Vector2(cos(i/TAU+PI),sin(i/TAU+PI)))
	
func targeted():
	"""
	Shoots 5 particles in sequence in to direction of players global position in the scene
	Selects sprite as frontfacing boss.
	Creates timer and awaits it to complete for shooting speed
	Calls shoot() function
	"""
	$Sprite.play("front")
	for i in range(5):
		if is_hit:
			is_hit = false
			return
		await get_tree().create_timer(0.2).timeout
		shoot(global_position.direction_to(player.global_position))

func raining():
	"""
	Shoots particles starting from waypoint5 and progressing left on screen
	Selects sprite as frontfacing boss.
	sets speed to 5
	Creates timer and awaits it to complete for shooting speed
	Calls shoot() function
	normalizes speed back to 300
	"""
	$Sprite.play("front")
	SPEED = 5
	for i in range(21):
		if is_hit:
			is_hit = false
			return
		global_position += Vector2(-10, 0) * SPEED
		await get_tree().create_timer(0.2).timeout
		shoot(global_position.direction_to(Vector2(global_position.x, -1)))
	SPEED = 300
	

func hit(damage):
	"""
	Mechanism for damage control of boss.
		parameters:
			* damage (int): damage dealt by player particle or melee attack
	 workflow:
		1) progresses phases through damage taken
		2) if 3 phases are done, runs TheEnd scene
	"""
	is_hit = true
	hits += damage

	if hits >= 10 and hits < 20:
		phase = 2
	elif hits >= 20 and hits < 30:
		phase = 3
	elif hits >= 30:
		# TODO exit anim
		var ed = dialogue.instantiate()
		add_child(ed)
		ed.end_of_level("Placeholder end of level")
		SceneHandler.loadScene("res://Assets/TheEnd/TheEnd.tscn")
	
func _physics_process(delta):
	"""
	not used / placeholder
	"""
	pass
	

func _on_start_boss_body_entered(body):
	"""
	Event when player enters the "StartBoss" (Area2D) that triggers bossfight
	"""
	# TODO refine start anim
	# Add border so no cheesing
	timer = Timer.new()
	var sd = dialogue.instantiate()
	sd.position.y -= 100
	timer.wait_time = 5
	timer.one_shot = true
	timer.connect("timeout",chooseAttack)
	add_child(timer)
	add_child(sd)
	timer.start()
	sd.start_of_level("Placeholder start of level")
	$Sprite.play("left")
	global_position = waypoints[2].global_position
	phase = 1
	trigger.queue_free()
