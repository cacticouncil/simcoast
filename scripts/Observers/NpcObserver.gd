extends "res://scripts/Observers/Observer.gd"
#Handles NPC triggers


func onNotify(event):
	# Plays some banger royalty free construction sfx
	if Global.newGame:
		if event.eventName == "Added Tile" && event.eventDescription == "Added Power Plant":
			var tutorial = preload("res://ui/hud/NPC_Interactions/Tutorial.tscn")
			var TutorialInstance = tutorial.instance()
			TutorialInstance.setCharacter(4)
			TutorialInstance.setSegment(1)
			add_child(TutorialInstance)
		if event.eventName == "Added Powered Tile":
			if event.eventDescription == "Added Commercial Area" || event.eventDescription == "Added Resedential Area":
				var tutorial = preload("res://ui/hud/NPC_Interactions/Tutorial.tscn")
				var TutorialInstance = tutorial.instance()
				TutorialInstance.setCharacter(4)
				TutorialInstance.setSegment(2)
				add_child(TutorialInstance)

func triggerDialogue(npcName):
	#Update state of the NPC
	var tutorial = preload("res://ui/hud/NPC_Interactions/Tutorial.tscn")
	var TutorialInstance = tutorial.instance()
	TutorialInstance.setCharacter(4)
	TutorialInstance.setSegment(1)
	add_child(TutorialInstance)

func initializeNPCs():
	pass # Happens once at the start of the program
	
