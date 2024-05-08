extends Node

#Used this video to help - https://www.youtube.com/watch?v=GzPvN5wsp7Y

#Keeps track of NPC frame
var currentFrame = 0

#Called when scene first enters the tree
func _ready():
	getNextText()

#Gets and displays next text
func getNextText():
	var nextText = NPCOrganizer.nextDialogue(2)
	#Node leaves scene when dialogue is done
	if (nextText == null):
		queue_free()
	else:
		$DialogueBox/Dialogue.bbcode_text = nextText
	return
func _on_NextButton_pressed():
	#Switches position of the character in a loop
	if (currentFrame == 4):
		currentFrame = 0
	$DialogueBox/Teacher.frame += 1
	getNextText()
	return
#TODO add JSON file to have "emotions" to set currentFrame
