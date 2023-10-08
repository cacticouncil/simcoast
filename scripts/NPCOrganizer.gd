extends Node


var npcDictionary: Dictionary
var npcCount = 0
var rng = RandomNumberGenerator.new()


func _ready():
	addNPC("Carl","res://resources/PLAYER.json", "res://resources/NPC.json")
func getNPCCount():
	return npcCount
# Prints list of all NPC names
func printNPCList():
	for n in self.npcDictionary.values():
		print(n.name + ", ")
	return
func addNPC(npcName_, playerDialogue, npcDialogue):
	#Should add NPC as the name given and give unique ID
	self.npcCount += 1
	#Have a way of encrypting this? So it is reversable
	var npcID
	while (true):
		npcID = rng.randi_range(0, 100000)
		if !npcDictionary.has(npcID):
			break
	var npcObject = NPC.new(npcID, npcName_, playerDialogue, npcDialogue)
	npcDictionary[npcID] = npcObject
	return
func deleteNPC(id_):
	npcDictionary.erase(id_)
	self.npcCount -= 1
	return
func setName(id_, newName):
	npcDictionary[id_].name = newName
	return

