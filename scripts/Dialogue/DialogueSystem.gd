class_name DialogueSystem extends Node

# keeps track of current dialogue sequence for npc and player
var currentNPC = 0
var currentPlayer = 0
var turn = true
var currentDialogue=""
var currentSequence = 0
var choices = false
var cd
var solo = false
# dialogue sequence for npc
var NPC_CONV = Dictionary()

# dialogue sequence for player
var PLAYER_CONV = Dictionary()


# gets the dialogue from json files
func _init(playerDialogue, npcDialogue):
	var npc = File.new()
	npc.open(npcDialogue, npc.READ)
	var text = npc.get_as_text()
	NPC_CONV = parse_json(text)
	npc.close()
	var player = File.new()
	player.open(playerDialogue, player.READ)
	var text2 = player.get_as_text()
	PLAYER_CONV = parse_json(text2)
	player.close()
	if (text == text2):
		solo = true
	
	


func get_next_dialogue():
	#npc sequence
	if (solo == true):
		if (int(currentNPC) == -2):
			currentPlayer = -2
			return
		currentDialogue = NPC_CONV[int(currentNPC)]["dialogue"]
		currentNPC = NPC_CONV[int(currentNPC)]["next"]
		return currentDialogue
	if (solo == false):
		if(turn == true):
			currentDialogue = NPC_CONV[int(currentNPC)]["dialogue"]
			# no player prompt
			if(NPC_CONV[int(currentNPC)]["next"] == "-1"):
				currentNPC = -2
			else:
				currentPlayer = NPC_CONV[int(currentNPC)]["next"]
				turn = false
			#print(currentDialogue)
			return currentDialogue
		#player sequence
		else:
			# end dialogue
			#print(currentPlayer)
			if(currentPlayer == "-2"):
				currentPlayer = -2
				return null
			currentDialogue=[]
			var cp = currentPlayer.split(",")
			for j in cp:
				currentDialogue.append(PLAYER_CONV[int(j)]["dialogue"])
			#print(currentDialogue)
			return currentDialogue

func nextNPCLine(d):
	for i in PLAYER_CONV:
		if (i["dialogue"] == d):
			currentNPC = i["next"]
			turn = true

func dialogueSequence(n):
	if(choices == true):
		if(n == 1):
			nextNPCLine(cd[0])
		elif (n == 2):
			nextNPCLine(cd[1])
		else:
			nextNPCLine(cd[0])
			
	cd = get_next_dialogue()
	if (typeof(cd) == TYPE_ARRAY && cd.size() != 1):
		choices = true
	if(solo == true && int(currentNPC) == -2):
		resetDialogue()
	elif(solo == false):		
		if(int(currentPlayer) == -2 && turn == false):
			resetDialogue()
	return cd
	
func resetDialogue():
	currentNPC = 0
	currentPlayer = 0
	turn = true
	currentDialogue = ""
	currentSequence = 0
#func _input(event):
#	if event is InputEventKey and event.pressed:
#		if event.keycode == KEY_1:
#			emit_signal("1")
#			currentSequence = 1
#			print("1")
#		if event.keycode == KEY_2:
#			currentSequence = 2
#			emit_signal("2")
#			print("2")
#		if event.keycode == KEY_3:
#			currentSequence = 3
#			emit_signal("3")
#			print("3")
#
