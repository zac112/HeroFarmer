extends Node2D

# speed of the particle
@export var speed = 350
# player scene
var target = null
# boss scene
var boss = null

func _ready():
	"""
	Run when instantiating the object:
		* Creates timer for lifetime of the missile and sets to 3 secs
		* Tween is used to create "spawn effect" from boss
		* Sets "target" and "boss" variables for position and direction of the particle
	"""
	var timer = get_tree().create_timer(3)
	timer.connect("timeout", lifetime_end)
	var missileScaleChange = create_tween()
	missileScaleChange.tween_property($Animation, 'scale', Vector2(2,2), 0.2).from(Vector2(0,0))
	target = get_parent().find_child("player_platform")
	boss = get_parent().find_child("Enemy_boss")
	self.global_position = boss.global_position

func _physics_process(_delta):
	"""
	Moves global position every render towards players known position aka homing
	Rotates sprite to "look at" the location of the player
	"""
	self.global_position = self.global_position.move_toward(target.global_position, _delta * speed)
	look_at(target.global_position)
		
func lifetime_end():
	""" deletes the particle """
	queue_free()

func _on_body_entered(body):
	""" signal to call players take_damage if collides with body """
	if body.name == "player_platform":
		if body.has_method("take_damage"):
			body.take_damage()
	lifetime_end()
