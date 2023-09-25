extends Node

# NPC structure:
# DialogueSystem
# functions for adding/removing/modifying
# listens for certain events to trigger interaction
# tracks what dialogue it can use at the moment
# uses dialogue ID to look up actual dialogs from the dialog system
# character ID for the NPC

var npcList = {}
var npcCount = 0


func addNPC(npcName_):
	#Should add NPC as the name given and give unique ID as ascii value of NPCName
	npcCount += 1
	var npcID = ord(npcName_)
	var npcObject = NPC.new(npcID, npcName_)
	npcList.append(npcObject)
	return
func deleteNPC(npcName_):
	npcCount -= 1
	return
func modifyNPC(npcName_):
	return

# Prints list of all NPC names
func printNPCList():
	for n in npcList:
		print(n.npcName)
		print("")
