extends Node

#Maps NPCs using IDs to NPC objects (see NPC.gd)
var npcDictionary: Dictionary
var npcCount = 0

#Add in the NPCs here with their json files
#Called only once to intialize the NPCs
func _ready():
	addNPC("Carl", 1, "res://resources/PLAYER.json", "res://resources/NPC.json")
	addNPC("Lydia", 2, "res://resources/shop.json", "res://resources/shop.json")
	addNPC("Expert", 3, "res://resources/expert.json", "res://resources/expert.json")
	addNPC("Maria", 4, "res://resources/tutorial.json", "res://resources/tutorial.json")

#Gets the number of NPCs
func getNPCCount():
	return npcCount

# Prints list of all NPC names
func printNPCList():
	for n in self.npcDictionary.values():
		print(n.name + ", ")
	return

#Adds NPC into dictionary as the name given and give unique ID
func addNPC(npcName, npcID, playerDialogue, npcDialogue):
	if (npcID in npcDictionary):
		print("Not unique ID!")
		return
	self.npcCount += 1
	var npcObject = NPC.new(npcID, npcName, playerDialogue, npcDialogue)
	npcDictionary[npcID] = npcObject
	return

#Deletes NPC by ID
func deleteNPC(id_):
	npcDictionary.erase(id_)
	self.npcCount -= 1
	return

#Sets the name of the NPC
func setName(id_, newName):
	npcDictionary[id_].name = newName
	return

#Access current dialogue and dialogue system
func dialogueTrigger(id_):
	npcDictionary[id_].dialogueSequence()
	return
func nextDialogue(id_, segment_):
	return npcDictionary[id_].dialogueSystem.get_next_dialogue(segment_)
