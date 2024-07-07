extends Area2D

const HARVEST_SOUND = preload("res://Assets/Audio/snow-harvesting-47809.wav")
const PLANT_SOUND = preload("res://Assets/Audio/moving-plant-75923.wav")

# Label for UI
@onready var plant_seed_label = %Label
@onready var harvest_seed_label = %Label2
@onready var growth_stage_label = %Label3
@onready var seed_sprite = %SeedSprite

var seed : Seed
@export var id : int

@onready var display_seed_list = %ItemList

var carrot_seed = load("res://Assets/Farm/Plot/Plant/Seeds/Carrot_seed.tres")
var turnip_seed = load("res://Assets/Farm/Plot/Plant/Seeds/Turnip_seed.tres")
var pumpkin_seed = load("res://Assets/Farm/Plot/Plant/Seeds/Pumpkin_seed.tres")
var seed_list = [carrot_seed, turnip_seed, pumpkin_seed]


var ready_to_harvest := false

var select_seed_id = -1

# Harvest cooldown so player doesn't instantly plant a new plant
var harvest_cooldown : float = 0.0
# Is player in range
var player_in_range := false

@onready var player = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	seed_sprite.animation = "-1"
	add_seeds_from_inventory()
	seed = FarmData.plot_list[id]
	display_seed_list.icon_scale=0.5
	if seed:
		seed.growth_stage += 1
		seed_sprite.animation = str(seed.id)
		seed_sprite.frame = 1
		update_growth_label()
		if seed.growth_stage >= seed.growth_time:
			seed_sprite.frame = 2
			ready_to_harvest = true

func add_seeds_from_inventory():
	display_seed_list.clear()
	for i in SeedInventory.inventory:
		if i.quantity > 0:
			display_seed_list.add_item(i.seed_name + "(" + str(i.quantity) + ")", i.seed_sprite)
		else:
			display_seed_list.add_item(i.seed_name + "(" + str(i.quantity) + ")", i.seed_sprite, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	harvest_cooldown -= delta
	if player_in_range:
		if Input.is_action_pressed("Farm_action"):
			if !seed and harvest_cooldown <= 0 and select_seed_id != -1:
				plant_seed(select_seed_id)
			if ready_to_harvest:
				harvest_plant()


func _on_body_entered(body):
	add_seeds_from_inventory()
	if !seed:
		plant_seed_label.visible = true
		display_seed_list.visible = true
	elif ready_to_harvest:
		harvest_seed_label.visible = true
	else:
		growth_stage_label.visible = true
	player_in_range = true


func _on_body_exited(_body):
	plant_seed_label.visible = false
	display_seed_list.visible = false
	harvest_seed_label.visible = false
	growth_stage_label.visible = false
	player_in_range = false

func plant_seed(seed_id:int):
	var new_seed = null
	if seed_id != -1:
		new_seed = seed_list[seed_id]
		
	if new_seed:
		plant_seed_label.visible = false
		display_seed_list.visible = false
		update_growth_label()
		growth_stage_label.visible = true
		seed_sprite.visible = true
		seed_sprite.animation = str(seed_id)
		seed_sprite.frame = 0
		#seed_sprite.texture = new_seed.seed_sprite
		# Create new instance of seed resource
		var temp_seed = Seed.new()
		temp_seed.seed_sprite = new_seed.seed_sprite
		temp_seed.seed_name = new_seed.seed_name
		temp_seed.growth_stage = new_seed.growth_stage
		temp_seed.growth_time = new_seed.growth_time
		temp_seed.id = seed_id
		seed = new_seed
		plant_seed_label.visible = false
		update_growth_label()
		growth_stage_label.visible = true
		SeedInventory.remove_seed(seed_id)
		FarmData.plot_list[id] = temp_seed
		SfxHandler.play(PLANT_SOUND, get_tree().current_scene)
	else:
		seed_sprite.animation = "-1"
		seed = null
		FarmData.plot_list[id] = null

func harvest_plant():
	CropInventory.pickup_crop(seed.id)
	plant_seed(-1)
	harvest_seed_label.visible = false
	ready_to_harvest = false
	harvest_cooldown = 0.2
	plant_seed_label.visible = true
	SfxHandler.play(HARVEST_SOUND, get_tree().current_scene)
	pass
	
func update_growth_label():
	if seed:
		growth_stage_label.text = "Growth stage: " + str(seed.growth_stage) + "/" + str(seed.growth_time)


func _on_item_list_item_selected(index):
	select_seed_id = SeedInventory.inventory[index].id
