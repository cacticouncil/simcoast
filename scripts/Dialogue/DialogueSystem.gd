class_name DialogueSystem extends Node

# keeps track of current dialogue sequence for npc and player
var currentNPC = 0
var currentPlayer = 0
var turn = true
var currentDialogue=""

# dialogue sequence for npc
var NPC_CONV = {}

# dialogue sequence for player
var PLAYER_CONV = {}


# gets the dialogue from json files
func _init(playerDialogue, npcDialogue):
	var npc = File.new()
	npc.open(npcDialogue, npc.READ)
	var text = npc.get_as_text()
	NPC_CONV.parse_json(text)
	npc.close()
	var player = File.new()
	player.open(playerDialogue, player.READ)
	var text2 = player.get_as_text()
	PLAYER_CONV.parse_json(text2)
	player.close()



func get_next_dialogue():
	#npc sequence
	if(turn == true):
		currentDialogue = NPC_CONV[currentNPC]["dialogue"]
		# no player prompt
		if(NPC_CONV[currentNPC]["next"] == "-1"):
			currentNPC = 4
		else:
			currentPlayer = NPC_CONV[currentNPC]["next"]
			turn = false
		#print(currentDialogue)
		return currentDialogue
	#player sequence
	else:
		# end dialogue
		if(currentPlayer == "-2"):
			return
		currentDialogue=[]
		var cp = currentPlayer.split(",")
		for j in cp:
			currentDialogue.append(PLAYER_CONV[int(j)]["dialogue"])
		#print(currentDialogue)
		return currentDialogue

func nextNPCLine(d):
	for i in PLAYER_CONV:
		if (PLAYER_CONV[i]["dialogue"] == d):
			currentNPC = PLAYER_CONV[i]["next"]
			turn = true
