extends Node

var carrot : CropItem = load("res://Assets/Inventory/crop_inventory/carrot.tres")
var pumpkin : CropItem = load("res://Assets/Inventory/crop_inventory/pumpkin.tres")
var turnip : CropItem = load("res://Assets/Inventory/crop_inventory/turnip.tres")
var tomato : CropItem = load("res://Assets/Inventory/crop_inventory/tomato.tres")
var wheat : CropItem = load("res://Assets/Inventory/crop_inventory/wheat.tres")


var crop_inventory = [carrot, turnip, pumpkin, tomato, wheat] 


func pickup_crop(crop_id : int):
	crop_inventory[crop_id].quantity += 1
	
func remove_crop(crop_id : int):
	crop_inventory[crop_id].quantity -= 1

