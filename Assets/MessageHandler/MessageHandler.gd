extends Node

"""
Example:
	MessageHandler.registerListener(ScoreEvent, self.ok)
	var event = ScoreEvent.new()
	event.scoreIncrease = 34
	MessageHandler.broadcastEvent(event)
"""

var eventListeners = {}

func registerListener(event, callback):	
	print("Registere")
	if !eventListeners.has(typeof(event)):
		eventListeners[typeof(event)] = []
	eventListeners[typeof(event)].append(callback)
	print("Registered")
	
func broadcastEvent(event):
	print("listeners:",eventListeners)
	for e in eventListeners.get(typeof(event), []):
		e.call(event)
