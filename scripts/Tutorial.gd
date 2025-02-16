extends Node

# What part of the tutorial we are on!
# This is updated by events
var segment = 0
var conv_index = 0
var current_conv

var scene_change = null
var scene_to_remove = null

# Called when scene first enters the tree
func _ready():
	$DialogueBox/Option0.connect("pressed", self, "_on_Option_pressed", [0])
	$DialogueBox/Option1.connect("pressed", self, "_on_Option_pressed", [1])
	$DialogueBox/Option2.connect("pressed", self, "_on_Option_pressed", [2])
	print("Tutorial scene created. Parent: " + get_parent().get_path())
	getNextText()

# Gets and displays next text
func getNextText():
	# Get the current conversation from array
	current_conv = TutorialData.convs[segment]
	
	# Check if the dialogue is null (end of conversation)
	if current_conv == null or current_conv.dialogues[conv_index] == null:
		# Remove the tutorial scene
		var city_map = get_parent()
		city_map.remove_child(self)
		print("Removed tutorial scene")
		
		# If there is a forced scene change
		if scene_change:
			print(city_map.get_path())
			
			# If the current scene needs to be removed upon the scene change
			if scene_to_remove:
				var child = city_map.get_node(scene_to_remove)
				city_map.remove_child(child)
				
			var scene = load(scene_change)
			var instance = scene.instance()
			city_map.add_child(instance)
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
		
		# Enable the options
		$DialogueBox/Option0.disabled = false
		$DialogueBox/Option1.disabled = false
		
		# Not always a 3rd option
		if choices[2]:
			$DialogueBox/Option2.text = choices[2].selection
			$DialogueBox/Option2.disabled = false
	
	display_char_photo_and_name(int(dialogue.char_id))
	
	# Unlock the character
	NPCOrganizer.unlockNPC(int(dialogue.char_id))
	
func display_char_photo_and_name(char_id: int):
	# Load the texture for the NPC
	var npc: NPC = NPCOrganizer.npcDictionary[char_id]
	var npc_icon = load(npc.icon)
	var npc_name = npc.name if npc.name != "PLAYER_NAME" else Global.userName
	$DialogueBox/SpeakerBox/Speaker.texture = npc_icon
	$DialogueBox/SpeakerBox/SpeakerName.bbcode_text = "[center]" + npc_name + "[/center]"

func _on_NextButton_pressed():
	getNextText()
	
func getSegment():
	return segment
func setSegment(segment_):
	segment = segment_
func getConvIndex():
	return conv_index


func disableOptions():
	$DialogueBox/Option0.disabled = true
	$DialogueBox/Option1.disabled = true
	$DialogueBox/Option2.disabled = true
	$DialogueBox/Option0.text = ""
	$DialogueBox/Option1.text = ""
	$DialogueBox/Option2.text = ""

func _on_Option_pressed(button_id: int):
	disableOptions()

	var choice = current_conv.dialogues[conv_index].choices[button_id]
	
	conv_index += choice.offset
	
	$DialogueBox/NextButton.disabled = false
	$DialogueBox/NextButton/Label.text = "NEXT"
	
	if choice.force_scene_change:
		scene_change = choice.scene_path
		if choice.remove_current:
			scene_to_remove = choice.current_path

	if choice.response == null:
		getNextText()
		return
	
	var text = choice.response.replace("PLAYER_NAME", Global.userName)

	$DialogueBox/Dialogue.bbcode_text = text
	
	display_char_photo_and_name(int(choice.char_id))
