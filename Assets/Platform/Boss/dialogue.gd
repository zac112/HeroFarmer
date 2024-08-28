extends Control

#content is a RichLabelText on which to display the actual message
@onready var content := get_node("Content")
#type_timer is a timer for adjusting the printing of characters to screen, initially set to 0.05 seconds
@onready var type_timer:= get_node("TypeTimer")
#placeholder for message string
var message = ""

func _ready():
	"""runs when object is generated along with setMessage(message) which sets the message that this updates"""
	await get_tree().create_timer(1.0).timeout
	update_message(message)
	#update_message("Welcome to my lair\n No more seeds for you...")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	""" not in use """
	pass
	
func setMessage(message):
	""" during instantiate call gets message as parameter, sets message and returns self """
	self.message = message
	return self

func update_message(message):
	""" function to control the displaying of the message"""
	content.bbcode_text = message
	content.visible_characters = 0
	type_timer.start()

func _on_type_timer_timeout():
	""" on type timer timeout, if has characters left to print, sets visible characters to one more than current, else waits 2 seconds for flow and stops """
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		await get_tree().create_timer(2.0).timeout
		type_timer.stop()

