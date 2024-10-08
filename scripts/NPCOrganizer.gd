extends Node

#Maps NPCs using IDs to NPC objects (see NPC.gd)
var npcDictionary: Dictionary = {}
var npcCount: int = 0

#Add in the NPCs here with their json files
#Called only once to intialize the NPCs
func _ready():
	addNPC("PLAYER_NAME", 0, "res://assets/characters/test_profession_icon.png", "")
	addNPC("Researcher", 1, "res://assets/characters/researcher_icon.png", "I am a researcher!")
	addNPC("Environmental Engineer", 2, "res://assets/characters/environmental_engineer_icon.png", "I am an environmental engineer!")
	addNPC("Scientist", 3, "res://assets/characters/scientist_icon.png", "I am a scientist!")
	addNPC("Test Profession", 4, "res://assets/characters/test_profession_icon.png", "I am definitely something!")
	addNPC("Test Profession2", 5, "res://assets/characters/test_profession_icon.png", "I am definitely something!")
	
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
func addNPC(npcName, npcID, npcIcon, npcDescription):
	if (npcID in npcDictionary):
		print("Not unique ID!")
		return
	self.npcCount += 1
	var npcObject = NPC.new(npcID, npcName, npcIcon, npcDescription)
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
	if (npcDictionary[id_].unlocked || npcDictionary[id_].name == "PLAYER_NAME"):
		return
	npcDictionary[id_].unlocked = true
	#Displays popup
	var pop = preload("res://ui/Popups/Overlay.tscn")
	var npcName = npcDictionary[id_].name
	print(npcName)
	var npcIcon = npcDictionary[id_].icon
	print(npcIcon)
	get_node("/root/Overlay").character_pop(npcName, npcIcon)
	return
