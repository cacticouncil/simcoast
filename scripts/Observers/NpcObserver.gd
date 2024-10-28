extends "res://scripts/Observers/Observer.gd"

var segment = 0

func onNotify(event):
	if Global.newGame:
		# Get the current conversation from the convs array
		var current_conv = TutorialData.convs[segment]
		# Check if the conditions to move on to the next segment are met
		if conditions_met(current_conv.conditions, event):
			print("Conditions met")
			print(event.eventName)
			print(event.eventDescription)
			# Load the tutorial instance
			var tutorial = preload("res://ui/hud/NPC_Interactions/Tutorial.tscn")
			var TutorialInstance = tutorial.instance()

			# Increment segment and set it in the tutorial scene
			segment += 1
			TutorialInstance.setSegment(segment)

			# Update current_conv to the new segment
			current_conv = TutorialData.convs[segment]

			# Get the parent and add tutorial scene as its child
			var parent = get_node(current_conv.dialogues[0].parent_path)
			parent.add_child(TutorialInstance)

func conditions_met(conditions, event):
	if not conditions.has("event_name") or conditions["event_name"] != event.eventName:
		return false
	if conditions.has("event_description"):
		var desc = conditions["event_description"]
		if desc is Array and not desc.has(event.eventDescription):
			return false
		elif desc is String and desc != event.eventDescription:
			return false
	return true

func triggerDialogue(npcName):
	#Update state of the NPC
	var tutorial = preload("res://ui/hud/NPC_Interactions/Tutorial.tscn")
	var TutorialInstance = tutorial.instance()
	TutorialInstance.setCharacter(1)
	TutorialInstance.setSegment(1)
	add_child(TutorialInstance)

func initializeNPCs():
	pass # Happens once at the start of the program
