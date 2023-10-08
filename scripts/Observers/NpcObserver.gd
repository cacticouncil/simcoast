extends "res://scripts/Observers/Observer.gd"
#Handles SFX

#export var sfxPlayer : AudioStreamPlayer

func onNotify(event, stats):
	# Plays some banger royalty free construction sfx
	if event.eventName == "Completed Mission":
		if event.eventValue == 0:
			print("Mission 0 Dialogue Start")
			NPCOrganizer.npcDictionary[1].dialogueTrigger()

func triggerDialogue(dialogue):
	pass # Happens when dialogue is triggered

func initializeNPCs():
	pass # Happens once at the start of the program
