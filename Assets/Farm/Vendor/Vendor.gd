extends Node

@onready var FarmMusic = $"../FarmMusic"
const HOW_SOUND = preload("res://Assets/Audio/how can i help you.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	$VendorUI.visible = false
	
func _process(delta):
	pass
	

func _on_area_2d_body_entered(body):
	$VendorUI.visible = true
	$VendorMusic.play()
	SfxHandler.play(HOW_SOUND, get_tree().current_scene)
	FarmMusic.stop()

func _on_area_2d_body_exited(body):
	$VendorUI.visible = false
	$VendorMusic.stop()
	FarmMusic.play()
