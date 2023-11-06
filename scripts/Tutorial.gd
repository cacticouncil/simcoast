extends Node

#Used this video to help - https://www.youtube.com/watch?v=GzPvN5wsp7Y

#Keeps track of NPC frame
var currentFrame = 0
var choice = 0
#Called when scene first enters the tree
func _ready():
	getNextText(choice)

#Gets and displays next text
func getNextText(choice):
	var nextText = NPCOrganizer.dialogueTrigger(1, choice)
	#Node leaves scene when dialogue is done
	if (nextText == null):
		get_parent().remove_child(self)
	elif (typeof(nextText) == TYPE_ARRAY):
		$DialogueBox/Option1/RichTextLabel.bbcode_text = nextText[0]
		$DialogueBox/Option2/RichTextLabel.bbcode_text = nextText[1]
	else:
		$DialogueBox/Dialogue.bbcode_text = nextText
	return
func _on_NextButton_pressed():
	#Switches position of the character in a loop
	if (currentFrame == 4):
		currentFrame = 0
	$DialogueBox/Teacher.frame += 1
	getNextText(choice)
	return
#func _on_Option1_pressed():
	#choice = 0
	#getNextText(choice)
	#return
func _on_Option1_pressed():
	choice = 1
	getNextText(choice)
func _on_Option2_pressed():
	choice = 2
	getNextText(choice)
func _on_Option3_pressed():
	print("Button 3 pressed!")
	choice = 3
	getNextText(choice)

#TODO add JSON file to have "emotions" to set currentFrame
