extends Node

var carrot : CropItem = load("res://Assets/Inventory/crop_inventory/carrot.tres")
var potato : CropItem = load("res://Assets/Inventory/crop_inventory/potato.tres")
var corn : CropItem = load("res://Assets/Inventory/crop_inventory/corn.tres")

var crop_inventory = [carrot, potato, corn] 


func pickup_crop(crop_id : int):
	crop_inventory[crop_id].quantity += 1
	
func remove_crop(crop_id : int):
	crop_inventory[crop_id].quantity -= 1
	print  ("Removed crop")
