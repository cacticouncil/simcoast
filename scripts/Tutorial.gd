extends Node

#Keeps track of NPC frame
var currentFrame = 0
var character = 1
#What part of the tutorial we are on!
#This is updated by events
var segment = 0
var conv_index = 0;
#Locked if waiting for action by user!
var locked = false

#Called when scene first enters the tree
func _ready():
	print("Tutorial instance created. Parent: " + String(get_parent().get_path()))
	getNextText()

func setCharacter(character):
	self.character = character
	NPCOrganizer.unlockNPC(character)

# Gets and displays next text
func getNextText():
	# Get the current conversation from array
	var current_conv = TutorialData.convs[segment]
	
	# Check if the dialogue is null (end of conversation)
	if current_conv.dialogues[conv_index] == null:
		# Remove the tutorial scene
		print("Removing tutorial scene")
		get_parent().remove_child(self)
		return
	
	# Get the dialogue from dialogues array
	var dialogue = current_conv.dialogues[conv_index]
	# Increment conv_index so that the next call will get the next dialogue
	conv_index += 1
	# Display the dialogue text
	var text = dialogue.text.replace("PLAYER_NAME", Global.userName)
	print(Global.userName)
	$DialogueBox/Dialogue.bbcode_text = text 

func _on_NextButton_pressed():
	#Switches position of the character in a loop
	if (!locked):
		if (currentFrame == 4):
			currentFrame = 0
		$DialogueBox/Teacher.frame += 1
		getNextText()
	return
func isLocked():
	return locked
func setLocked(locked_):
	locked = locked_
func getSegment():
	return segment
func setSegment(segment_):
	segment = segment_
func getConvIndex():
	return conv_index
#TODO add JSON file to have "emotions" to set currentFrame
