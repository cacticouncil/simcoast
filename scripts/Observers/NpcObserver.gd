extends "res://scripts/Observers/Observer.gd"
#Handles NPC triggers

#export var sfxPlayer : AudioStreamPlayer

func onNotify(event, stats):
	# Plays some banger royalty free construction sfx
	if event.eventName == "Added Tile":
		if event.eventValue == 1:
			print("Added Tile Dialogue Start")
			NPCOrganizer.npcDictionary[1].dialogueTrigger()

func triggerDialogue(dialogue):
	pass # Happens when dialogue is triggered

func initializeNPCs():
	pass # Happens once at the start of the program
