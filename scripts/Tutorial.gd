extends Node

#Used this video to help - https://www.youtube.com/watch?v=GzPvN5wsp7Y

#Keeps track of NPC frame
var currentFrame = 0
var character = 1
#What part of the tutorial we are on!
#This is updated by events
var segment = 0
var conv_index = 0;
#Locked if waiting for action by user!
var locked = false

# Necessary Objects
var Conversation = load("res://scripts/Dialogue/Conversation.gd")
var Dialogue = load("res://scripts/Dialogue/Dialogue.gd")
var Options = load("res://scripts/Dialogue/Options.gd")

# Array of Conversation objects
# Currently, 1 is a placeholder for the Maria character
var convs = [
	Conversation.new([
		Dialogue.new("Hello, Mayor PLAYER_NAME! Welcome to Shore City. I’m so happy to have you as our new mayor. We’re a small community right now, but I’m sure you can lead us to becoming a bustling city.", 1),
		Dialogue.new("My name is Maria. Let me give you a tour of the city as I explain your role as mayor.", 1),
		Dialogue.new("This is the map of the city. On the left are the tools you need to build infrastructure around town. Powerplants power all the buildings in town. Go ahead and place a power plant.", 1),
		null
	], {"event_name": "Added Tile", "event_description": "Added Power Plant"}),
	Conversation.new([
		Dialogue.new("Placing new buildings costs money. The town has started with a modest budget but you can earn more taxes as new citizens move in.  Now place a building and connect it with a road.", 1),
		null
	], {"event_name": "Added Powered Tile", "event_description": ["Added Commercial Area", "Added Resedential Area"]}),
	Conversation.new([
		Dialogue.new("Look at that. Now we have new people moving in! I’m so excited, Mayor PLAYER_NAME. Our city is growing. As the city grows, it’s important to pay attention to the impact your decisions have on citizens. Let’s check out the dashboard.", 1),
		null
	], {"event_name": "Dashboard", "event_description": "Entered"}),
	Conversation.new([
		Dialogue.new("This is your dashboard. This is where you can monitor citizens’ happiness, change tax rates, and monitor sensors. Take a look around. I’ll be waiting for you at the store when you’re ready.", 1),
		null
	], {"event_name": "Store", "event_description": "Entered"}),
	Conversation.new([
		Dialogue.new("Thanks for joining me, Mayor. This is the shop where you can purchase sensors. Sensors help monitor the weather. Because our city is right next to the ocean, we use sensors to let us know if there’s a storm approaching.", 1),
		Dialogue.new("Sensors are expensive but they’re good investments. Luckily, the city has received a donated tide gauge, so this one is free. You can go ahead and accept it, Mayor.", 1),
		null
	], {"event_name": "Info popup", "event_description": "Closed"}),
	Conversation.new([
		Dialogue.new("After you've purchased a sensor, you can learn even more about it by talking to Dr. Clarke. Dr Clarke is our resident evironmental scientist. He's very knowledgeable about sensors and how they impact that environment. When you're ready to meet with him, click on \"learn more\" on the tide gauge to to head on over to the lab.", 1),
		null
	], {}),
	null
]

#Called when scene first enters the tree
func _ready():
	print("Tutorial instance created. Parent: " + String(get_parent().get_path()))
	getNextText()

func setCharacter(character):
	self.character = character
	NPCOrganizer.unlockNPC(character)
#Gets and displays next text
func getNextText():
	# segment indexes the right conversation
	# conv_index is the dialogue in the conversation
	print("conv_index (Tutorial): " + String(conv_index))
	print("segment (Tutorial): " + String(segment))
	var current_conv = convs[segment]
	#Node leaves scene when dialogue is done
	if (current_conv == null || current_conv.getDialogue(conv_index) == null):
		print("Removing tutorial scene")
		get_parent().remove_child(self)
		return
	var nextText = current_conv.getDialogue(conv_index).getText()
	conv_index += 1
	$DialogueBox/Dialogue.bbcode_text = nextText
	return
	
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
	self.locked = locked_
func getSegment():
	return segment
func setSegment(segment_):
	self.segment = segment_
func getConvIndex():
	return conv_index
#TODO add JSON file to have "emotions" to set currentFrame
