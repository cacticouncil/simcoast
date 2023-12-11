extends Node

#Used this video to help - https://www.youtube.com/watch?v=GzPvN5wsp7Y

#Keeps track of NPC frame
var currentFrame = 0
var choice = 0
var npc = 3
var singular = true
#Called when scene first enters the tree
func dialogueSetup(npc_):
	npc = npc_
	singular = NPCOrganizer.npcDictionary[npc].dialogueSystem.solo
	getNextText(npc, choice)
#Called to intiialize the scene's variables
#func _init(npc_):
	#npc = npc_

#Gets and displays next text
func getNextText(npc, choice):
	if (singular):
		$DialogueBox/Option1.visible = false
		$DialogueBox/Option2.visible = false
		$DialogueBox/Option3.visible = false
		var nextText = NPCOrganizer.dialogueTrigger(npc, choice)
		if (nextText == null):
			get_parent().remove_child(self)
		else:
			updateDialogueBox(nextText)
		return
	var nextText = NPCOrganizer.dialogueTrigger(npc, choice)
	#Node leaves scene when dialogue is done
	if (nextText == null):
		get_parent().remove_child(self)
	elif (typeof(nextText) == TYPE_ARRAY):
		#Reset dialogue boxes
		updateChoices(nextText)
	else:
		if (nextText.find("Correct") != -1):
			Announcer.notify(Event.new("Unlocked Badge", "Water Cycle", 0))
		updateDialogueBox(nextText)
	return
func _on_NextButton_pressed():
	#Switches position of the character in a loop
	if (currentFrame == 4):
		currentFrame = 0
	$DialogueBox/Teacher.frame += 1
	getNextText(npc, choice)
	return

func _on_Option1_pressed():
	if (currentFrame == 4):
		currentFrame = 0
	$DialogueBox/Teacher.frame += 1
	choice = 1
	getNextText(npc, choice)
	return
func _on_Option2_pressed():
	if (currentFrame == 4):
		currentFrame = 0
	$DialogueBox/Teacher.frame += 1
	choice = 2
	getNextText(npc, choice)
	return
func _on_Option3_pressed():
	if (currentFrame == 4):
		currentFrame = 0
	$DialogueBox/Teacher.frame += 1
	choice = 3
	getNextText(npc, choice)
	return

#TODO add JSON file to have "emotions" to set currentFrame
func updateDialogueBox(text):
	#do something
	$DialogueBox/Dialogue.bbcode_text = text
func updateChoices(text):
	#do something else
	$DialogueBox/Option2.visible = false
	$DialogueBox/Option3.visible = false
		
	$DialogueBox/Option1.visible = true
	$DialogueBox/Option1/RichTextLabel.bbcode_text = text[0]
	if (text.size() > 1):
		$DialogueBox/Option2.visible = true
		$DialogueBox/Option2/RichTextLabel.bbcode_text = text[1]
	if (text.size() > 2):
		$DialogueBox/Option3.visible = true
		$DialogueBox/Option3/RichTextLabel.bbcode_text = text[2]

func _on_Exit_pressed():
	NPCOrganizer.dialogueReset(npc)
	get_parent().remove_child(self)
