extends Node


@export var powerup : PowerupItem
@export var acquire_powerup = "res://Assets/Inventory/powerups/powerup_inventory.gd"
var inventory = [] 

func add_powerup(powerup_id : int):
	if powerup_id == 1:
		acquire_powerup.has_shoot = true
	if powerup_id == 2:
		acquire_powerup.has_double_jump = true	
	if powerup_id == 3:
		acquire_powerup.has_rapid_fire = true	
	if powerup_id == 4:
		acquire_powerup.has_double_dmg = true
	if powerup_id == 5:
		acquire_powerup.has_shield = true
