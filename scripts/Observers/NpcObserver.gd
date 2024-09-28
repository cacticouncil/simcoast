extends "res://scripts/Observers/Observer.gd"
#Handles NPC triggers
var segment = 0

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

func onNotify(event):
	# Plays some banger royalty free construction sfx
	if Global.newGame:
		var current_conv = convs[segment]
		# Check if conditon to move on from segment was met
		if current_conv != null and current_conv.conditions_met(event):
			print("Conditions met")
			# Create a tutorial instance
			var tutorial = preload("res://ui/hud/NPC_Interactions/Tutorial.tscn")
			var TutorialInstance = tutorial.instance()
			TutorialInstance.setCharacter(1)
			
			# Increment segment and set the segment for the tutorial instance
			segment += 1
			TutorialInstance.setSegment(segment)
			
			print("conv_index (NpcObserver): " + String(TutorialInstance.getConvIndex()))
			print("Segment (NpcObserver): " + String(TutorialInstance.getSegment()))
			
			# Get the new current conv
			current_conv = convs[segment]
			# Retrieve the node that is to be the parent of the tutorial instance
			var parent = get_node(current_conv.getDialogue(0).getParent())
			print("Parent of tutorial: " + parent.get_path())
			parent.add_child(TutorialInstance)

func triggerDialogue(npcName):
	#Update state of the NPC
	var tutorial = preload("res://ui/hud/NPC_Interactions/Tutorial.tscn")
	var TutorialInstance = tutorial.instance()
	TutorialInstance.setCharacter(1)
	TutorialInstance.setSegment(1)
	add_child(TutorialInstance)

func initializeNPCs():
	pass # Happens once at the start of the program
	
