extends Object

class_name Conversation
var conv: Array
var conditions: Dictionary

func _init(_conv: Array, _conditions: Dictionary):
	conv = _conv
	conditions = _conditions

func conditions_met(event):
	if !conditions.has("event_name") or conditions["event_name"] != event.eventName:
		return false
	if conditions.has("event_description"):
		var desc = conditions["event_description"]
		if desc is Array and not desc.has(event.eventDescription):
			return false
		elif desc is String and desc != event.eventDescription:
			return false
	return true

func getDialogue(index: int):
	return conv[index]
