extends Node

@onready var FarmMusic = $"../FarmMusic"
const HOW_SOUND = preload("res://Assets/Audio/how can i help you.wav")


var select_powerup_id = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$VendorUI.visible = false
	$ItemList.visible = false
	
func _process(delta):
	pass
	

func _on_area_2d_body_entered(body):
	$ItemList.visible = true
	$VendorMusic.play()
	SfxHandler.play(HOW_SOUND, get_tree().current_scene)
	FarmMusic.stop()


func _on_area_2d_body_exited(body):
	$ItemList.visible = false
	$VendorMusic.stop()
	FarmMusic.play()

func buy_powerup(select_powerup_id: int):
	if CropInventory.inventory[select_powerup_id].quantity > 0:
		CropInventory.remove_crop(select_powerup_id)
		PowerupsInventory.add_powerup(select_powerup_id)
		print ("purchase")

func _on_item_list_item_selected(index):
	select_powerup_id = PowerupsInventory.inventory[index].id
