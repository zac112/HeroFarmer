extends Control


@onready var content := get_node("Content") as RichTextLabel
@onready var type_timer:= get_node("TypeTimer") as Timer
@onready var pause_timer := get_node("PauseTimer") as Timer

var message = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1.0).timeout
	update_message(message)
	#update_message("Welcome to my lair\n No more seeds for you...")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setMessage(message):
	self.message = message
	return self

func update_message(message):
	content.bbcode_text = message
	content.visible_characters = 0
	type_timer.start()

func _on_type_timer_timeout():
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		await get_tree().create_timer(2.0).timeout
		type_timer.stop()

