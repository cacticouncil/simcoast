extends "res://scripts/Observers/Observer.gd"
#Handles SFX

#export var sfxPlayer : AudioStreamPlayer

func onNotify(event):
	# Plays some banger royalty free construction sfx
	if event.eventName == "Completed Mission":
		if event.eventValue == 0:
			print("Mission 0 Dialogue Start")
			triggerDialogue("Inputs here")

func triggerDialogue(dialogue):
	pass # Happens when dialogue is triggered

func initializeNPCs():
	pass # Happens once at the start of the program
	
