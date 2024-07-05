extends Area2D

@onready var label = %Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(_body):
	label.visible = true
	print("Body entered")
	pass # Replace with function body.


func _on_body_exited(_body):
	label.visible = false
	pass # Replace with function body.
