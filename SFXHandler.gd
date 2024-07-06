extends Node2D

func play(sound: AudioStream, parent: Node):
	if sound != null and parent != null:
		var stream = AudioStreamPlayer.new()
		
		stream.stream = sound
		stream.finished.connect(func(): stream.queue_free())
		
		parent.add_child(stream)
		stream.play()
