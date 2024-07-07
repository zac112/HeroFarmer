extends Node


@export var powerup : PowerupItem


func add_powerup(powerup_id : int):
	print ("Added powerup")
	if powerup_id == 0:
		PowerupInventory.has_shoot = true
	if powerup_id == 1:
		PowerupInventory.has_double_jump = true	
	if powerup_id == 2:
		PowerupInventory.has_rapid_fire = true	

