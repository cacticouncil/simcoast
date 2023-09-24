class_name DialogueSystem extends Node

# keeps track of current dialogue sequence for npc and player
var currentNPC = 1
var currentPlayer = 1
var turn = true
var currentDialogue=""

# dialogue sequence for npc
const NPC_CONV = {
1:{
	"dialogue":"Welcome to city hall! How can I help you today?",
	"next":[1,2]
},
2:{
	"dialogue":"You don't have any achievements yet.",
	"next":[-1]
},
	
3:{
	"dialogue":"Maybe try building more houses!",
	"next":[3,4]
},
4:{
	"dialogue":"Maybe try adding a commercial zone!",
	"next":[-1]
	
},
5:{
	"dialogue":"See you next time!",
	"next":[0]
}
}

# dialogue sequence for player
const PLAYER_CONV = {
1:{
	"dialogue":"I want to see my achievements",
	"next":2
},
2:{
	"dialogue":"I want suggestions",
	"next":3
},
3:{
	"dialogue":"I want a different suggestion",
	"next":4
},
4:{
	"dialogue":"Thanks",
	"next":5
}
}

# Called when the node enters the scene tree for the first time.
func get_next_dialogue():
	#npc sequence
	if(turn == true):
		currentDialogue = NPC_CONV[currentNPC]["dialogue"]
		# no player prompt
		if(NPC_CONV[currentNPC]["next"] == [-1]):
			currentNPC = 5
		else:
			currentPlayer = NPC_CONV[currentNPC]["next"]
			turn = false
		#print(currentDialogue)
		return currentDialogue
	#player sequence
	else:
		# end dialogue
		if(currentPlayer == [0]):
			return
		currentDialogue=[]
		for j in currentPlayer:
			currentDialogue.append(PLAYER_CONV[j]["dialogue"])
		#print(currentDialogue)
		return currentDialogue

func nextNPCLine(d):
	for i in PLAYER_CONV:
		if (PLAYER_CONV[i]["dialogue"] == d):
			currentNPC = PLAYER_CONV[i]["next"]
			turn = true

