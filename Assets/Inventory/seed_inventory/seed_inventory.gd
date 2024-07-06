extends Node

var carrot_seed : SeedItem = load("res://Assets/Inventory/seed_inventory/carrot_seed.tres")
var turnip_seed : SeedItem = load("res://Assets/Inventory/seed_inventory/turnip_seed.tres")
var inventory = [carrot_seed, turnip_seed] 

func pickup_seed(seed_id : int):
	inventory[seed_id].quantity += 1
	
func remove_seed(seed_id : int):
	inventory[seed_id].quantity -= 1
	
