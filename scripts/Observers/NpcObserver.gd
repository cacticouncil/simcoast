extends "res://scripts/Observers/Observer.gd"
#Handles NPC triggers



func onNotify(event):
	# Will call the dialogue based on the name/id of the NPC
	if event.eventName == "Carl":
		if event.eventValue == 1:
			print("A wild Carl appears!")
			NPCOrganizer.dialogueTrigger(1)

func triggerDialogue(dialogue):
	pass # Happens when dialogue is triggered

func initializeNPCs():
	pass # Happens once at the start of the program
	
