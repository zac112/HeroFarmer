extends Node

@onready var FarmMusic = $"../FarmMusic"
const HOW_SOUND = preload("res://Assets/Audio/how can i help you.wav")


var select_powerup_id = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$ItemList.visible = false
	$ItemList.set_item_text(0, "Shooting \n Price: 1 Carrot ("+str(CropInventory.crop_inventory[0].quantity) +")")
	$ItemList.set_item_text(1, "Double Jump \n Price: 1 Turnip ("+str(CropInventory.crop_inventory[1].quantity) +")")
	$ItemList.set_item_text(2, "Rapid Fire \n Price: 1 Pumpkin ("+str(CropInventory.crop_inventory[2].quantity) +")")
func _process(delta):
	pass

func update_items():
	if PowerupInventory.has_shoot:
		$ItemList.set_item_text(0, "Already purchased")
	else:
		$ItemList.set_item_text(0, "Shooting \n Price: 1 Carrot ("+str(CropInventory.crop_inventory[0].quantity) +")")
	if PowerupInventory.has_double_jump:
		$ItemList.set_item_text(1, "Already purchased")
	else:	
		$ItemList.set_item_text(1, "Double Jump \n Price: 1 Turnip ("+str(CropInventory.crop_inventory[1].quantity) +")")
	if PowerupInventory.has_rapid_fire:
		$ItemList.set_item_text(2, "Already purchased")
	else:
		$ItemList.set_item_text(2, "Rapid Fire \n Price: 1 Pumpkin ("+str(CropInventory.crop_inventory[2].quantity) +")")
	
func _on_area_2d_body_entered(body):
	$ItemList.visible = true
	$VendorMusic.play()
	SfxHandler.play(HOW_SOUND, get_tree().current_scene)
	FarmMusic.stop()
	update_items()


func _on_area_2d_body_exited(body):
	$ItemList.visible = false
	$VendorMusic.stop()
	FarmMusic.play()

func buy_powerup(select_powerup_id: int):
	update_items()
	if CropInventory.crop_inventory[select_powerup_id].quantity > 0:
		CropInventory.remove_crop(select_powerup_id)
		PowerupsInventory.add_powerup(select_powerup_id)
	select_powerup_id = -1	


func _on_item_list_item_selected(index):
	select_powerup_id = index
	if select_powerup_id >= 0:
		buy_powerup(select_powerup_id)


