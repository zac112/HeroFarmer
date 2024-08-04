extends Node2D

var char_spawn = 0.2
var current_char = 0
var message_to_show = ""
var display = ""
var selection = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_sb = StyleBoxFlat.new()
	new_sb.bg_color = Color.BLACK
	$HBoxContainer/Label.add_theme_stylebox_override("normal",new_sb)

func start_of_level(message: String):
	message_to_show = message
	$CharacterTimer.set_wait_time(0.1)
	$CharacterTimer.start()
	
	
func end_of_level(message: String):
	message_to_show = message
	$CharacterTimer.set_wait_time(0.1)
	$CharacterTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_character_timer_timeout():
	if (current_char < len(message_to_show)):
		var next_char = message_to_show[current_char]
		display += next_char
		
		$HBoxContainer/Label.text = display
		current_char += 1
	else:
		$HBoxContainer.visible = false
