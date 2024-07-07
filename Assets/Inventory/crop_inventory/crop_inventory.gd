extends Node

@export var carrot : CropItem

var inventory = [carrot] 

func pickup_crop(crop_id : int):
	inventory[crop_id].quantity += 1
	
func remove_crop(crop_id : int):
	inventory[crop_id].quantity -= 1
