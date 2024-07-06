extends Area2D

@onready var sprite = %Sprite2D
var seed : Seed

func change_sprite(new_sprite : Texture2D):
	sprite.texture = new_sprite


func _on_body_entered(_body):
	SeedInventory.pickup_seed(seed.id)
	queue_free()
