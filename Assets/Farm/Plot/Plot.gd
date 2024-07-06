extends Area2D


# Label for UI
@onready var plant_seed_label = %Label
@onready var harvest_seed_label = %Label2
@onready var growth_stage_label = %Label3
@onready var seed_sprite = %SeedSprite
var seed : Seed
@export var id : int

var ready_to_harvest := false

# Is player in range
var player_in_range := false

@onready var player = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	seed = FarmData.plot_list[id]
	print(FarmData.plot_list)
	if seed:
		print(seed.growth_stage)
		seed.growth_stage += 1
		seed_sprite.texture = seed.seed_sprite
		update_growth_label()
		if seed.growth_stage >= seed.growth_time:
			ready_to_harvest = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_in_range:
		if Input.is_action_pressed("Farm_action"):
			if !seed:
				var seeds = player.get_seeds()
				plant_seed(seeds[0])
			if ready_to_harvest:
				harvest_plant()


func _on_body_entered(body):
	if !seed:
		plant_seed_label.visible = true
	elif ready_to_harvest:
		harvest_seed_label.visible = true
	else:
		growth_stage_label.visible = true
	player_in_range = true


func _on_body_exited(_body):
	plant_seed_label.visible = false
	harvest_seed_label.visible = false
	growth_stage_label.visible = false
	player_in_range = false

func plant_seed(new_seed:Seed):
	if new_seed:
		plant_seed_label.visible = false
		update_growth_label()
		growth_stage_label.visible = true
		seed_sprite.visible = true
		seed_sprite.texture = new_seed.seed_sprite
		# Create new instance of seed resource
		var temp_seed = Seed.new()
		temp_seed.seed_sprite = new_seed.seed_sprite
		temp_seed.seed_name = new_seed.seed_name
		temp_seed.growth_stage = new_seed.growth_stage
		temp_seed.growth_time = new_seed.growth_time
		seed = new_seed
		plant_seed_label.visible = false
		update_growth_label()
		growth_stage_label.visible = true
		FarmData.plot_list[id] = temp_seed
		
	else:
		seed_sprite.texture = null
		seed = null
		FarmData.plot_list[id] = null

func harvest_plant():
	plant_seed(null)
	harvest_seed_label.visible = false
	pass
	
func update_growth_label():
	if seed:
		growth_stage_label.text = "Growth stage: " + str(seed.growth_stage) + "/" + str(seed.growth_time)
