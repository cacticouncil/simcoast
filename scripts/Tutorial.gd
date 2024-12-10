extends Node

#Keeps track of NPC frame
var currentFrame = 0
var character = 1
#What part of the tutorial we are on!
#This is updated by events
var segment = 0
var conv_index = 0;

#Called when scene first enters the tree
func _ready():
	print("Tutorial scene created. Parent: " + get_parent().get_path())
	getNextText()

# Gets and displays next text
func getNextText():
	# Get the current conversation from array
	var current_conv = TutorialData.convs[segment]
	
	# Check if the dialogue is null (end of conversation)
	if current_conv.dialogues[conv_index] == null:
		# Remove the tutorial scene
		get_parent().remove_child(self)
		return
	
	# Get the dialogue from dialogues array
	var dialogue = current_conv.dialogues[conv_index]
	# Increment conv_index so that the next call will get the next dialogue
	conv_index += 1
	# Display the dialogue text
	var text = dialogue.text.replace("PLAYER_NAME", Global.userName)
	$DialogueBox/Dialogue.bbcode_text = text
	
	# Load the texture for the NPC
	var npc: NPC = NPCOrganizer.npcDictionary[int(dialogue.char_id)]
	var npc_icon = load(npc.icon)
	var npc_name = npc.name if npc.name != "PLAYER_NAME" else Global.userName
	$DialogueBox/SpeakerBox/Speaker.texture = npc_icon
	$DialogueBox/SpeakerBox/SpeakerName.bbcode_text = "[center]" + npc_name + "[/center]"
	
	# Unlock the character
	NPCOrganizer.unlockNPC(int(dialogue.char_id))

func _on_NextButton_pressed():
	getNextText()
	
func getSegment():
	return segment
func setSegment(segment_):
	segment = segment_
func getConvIndex():
	return conv_index
