extends Node

# What part of the tutorial we are on!
# This is updated by events
var segment = 0
var conv_index = 0
var current_conv

var scene_change = null

# Called when scene first enters the tree
func _ready():
	print("Tutorial scene created. Parent: " + get_parent().get_path())
	getNextText()

# Gets and displays next text
func getNextText():
	# Get the current conversation from array
	current_conv = TutorialData.convs[segment]
	
	# Check if the dialogue is null (end of conversation)
	if current_conv.dialogues[conv_index] == null:
		# Remove the tutorial scene
		var parent = get_parent()
		parent.remove_child(self)
		print("Removed tutorial scene")
		
		# If there is a forced scene change
		if scene_change:
			print(parent.get_path())
			var scene = load(scene_change)
			var instance = scene.instance()
			parent.add_child(instance)
			scene_change = null
			
		return
	
	var dialogue = current_conv.dialogues[conv_index]
	
	# DIALOGUE CASE
	if dialogue.type == "Dialogue":
		# Get the dialogue from dialogues array
		# Increment conv_index so that the next call will get the next dialogue
		conv_index += 1
		# Display the dialogue text
		var text = dialogue.text.replace("PLAYER_NAME", Global.userName)
		$DialogueBox/Dialogue.bbcode_text = text
	
	# OPTIONS CASE
	else:
		# Make the next button disappear as well as the dialogue
		$DialogueBox/NextButton.disabled = true
		$DialogueBox/NextButton/Label.text = ""
		$DialogueBox/Dialogue.bbcode_text = ""
		
		var choices = dialogue.choices
		
		# Put the text on the screen
		$DialogueBox/Option0.text = choices[0].selection
		$DialogueBox/Option1.text = choices[1].selection
		
		# Not always a 3rd option
		if choices[2]:
			$DialogueBox/Option2.text = choices[2].selection
		
		
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


func disableOptions():
	$DialogueBox/Option0.disabled = false
	$DialogueBox/Option1.disabled = false
	$DialogueBox/Option2.disabled = false
	$DialogueBox/Option0.text = ""
	$DialogueBox/Option1.text = ""
	$DialogueBox/Option2.text = ""

func _on_Option0_pressed():
	disableOptions()
	var choice = current_conv.dialogues[conv_index].choices[0]
	
	conv_index += choice.offset
	
	$DialogueBox/NextButton.disabled = false
	$DialogueBox/NextButton/Label.text = "NEXT"
	
	if choice.force_scene_change:
		scene_change = choice.scene_path

	if choice.response == null:
		getNextText()
		return
	
	var text = choice.response.replace("PLAYER_NAME", Global.userName)

	$DialogueBox/Dialogue.bbcode_text = text

func _on_Option1_pressed():
	disableOptions()
	var choice = current_conv.dialogues[conv_index].choices[1]
	
	conv_index += choice.offset
	
	$DialogueBox/NextButton.disabled = false
	$DialogueBox/NextButton/Label.text = "NEXT"
	
	if choice.force_scene_change:
		scene_change = choice.scene_path

	if choice.response == null:
		getNextText()
		return
	
	var text = choice.response.replace("PLAYER_NAME", Global.userName)

	$DialogueBox/Dialogue.bbcode_text = text


func _on_Option2_pressed():
	disableOptions()
	var choice = current_conv.dialogues[conv_index].choices[2]
	
	conv_index += choice.offset
	
	$DialogueBox/NextButton.disabled = false
	$DialogueBox/NextButton/Label.text = "NEXT"
	
	if choice.force_scene_change:
		scene_change = choice.scene_path

	if choice.response == null:
		getNextText()
		return
	
	var text = choice.response.replace("PLAYER_NAME", Global.userName)

	$DialogueBox/Dialogue.bbcode_text = text
