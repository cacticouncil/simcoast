extends Node

#Maps NPCs using IDs to NPC objects (see NPC.gd)
var npcDictionary: Dictionary
var npcCount = 0

#Add in the NPCs here with their json files
#Called only once to intialize the NPCs
func _ready():
	addNPC("Researcher", 1, "res://resources/tutorial.json", "res://resources/tutorial.json", "res://assets/characters/researcher_icon.png", "I am a researcher!")
	addNPC("Environmental Engineer", 2, "res://resources/shop.json", "res://resources/shop.json", "res://assets/characters/environmental_engineer_icon.png", "I am an environmental engineer!")
	addNPC("Scientist", 3, "res://resources/tutorial.json", "res://resources/tutorial.json", "res://assets/characters/scientist_icon.png", "I am a scientist!")
	addNPC("Test Profession", 4, "res://resources/tutorial.json", "res://resources/tutorial.json", "res://assets/characters/test_profession_icon.png", "I am definitely something!")
	addNPC("Test Profession2", 5, "res://resources/tutorial.json", "res://resources/tutorial.json", "res://assets/characters/test_profession_icon.png", "I am definitely something!")
	
#Gets the number of NPCs
func getNPCCount():
	return npcCount

# Prints list of all NPC names
func printNPCList():
	for n in self.npcDictionary.values():
		print(n.name + ", ")
	return
#Returns array of all NPC objects
func getNPCs():
	var npcs = []
	for n in self.npcDictionary.values():
		npcs.append(n)
	return npcs
#Adds NPC into dictionary as the name given and give unique ID
func addNPC(npcName, npcID, playerDialogue, npcDialogue, npcIcon, npcDescription):
	if (npcID in npcDictionary):
		print("Not unique ID!")
		return
	self.npcCount += 1
	var npcObject = NPC.new(npcID, npcName, playerDialogue, npcDialogue, npcIcon, npcDescription)
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
#Unlocks the NPC (for character cards)
func unlockNPC(id_):
	npcDictionary[id_].unlocked = true
	return
#Access current dialogue and dialogue system
func dialogueTrigger(id_):
	npcDictionary[id_].dialogueSequence()
	return
func nextDialogue(id_, segment_):
	return npcDictionary[id_].dialogueSystem.get_next_dialogue(segment_)
