extends Node

@onready var bg2 = $"../Background2"

# Called when the node enters the scene tree for the first time.
func _ready():
	$VendorUI.visible = false
	
func _process(delta):
	pass
	
	


func _on_area_2d_body_entered(body):
	$VendorUI.visible = true
	$Background.play()
	bg2.stop()

func _on_area_2d_body_exited(body):
	$VendorUI.visible = false
	$Background.stop()
	bg2.play()
