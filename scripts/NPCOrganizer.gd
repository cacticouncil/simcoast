extends Node




var npcDictionary: Dictionary
var npcCount = 0
var rng = RandomNumberGenerator.new()


func _ready():
	addNPC("Carl")
func getNPCCount():
	return npcCount
# Prints list of all NPC names
func printNPCList():
	for n in self.npcDictionary.values():
		print(n.name + ", ")
	return
func addNPC(npcName_):
	#Should add NPC as the name given and give unique ID
	self.npcCount += 1
	#Have a way of encrypting this? So it is reversable
	var npcID = rng.randi_range(0, 100000)
	var npcObject = NPC.new(npcID, npcName_)
	npcDictionary[npcID] = npcObject
	return
func deleteNPC(id_):
	#npcList.find()
	npcDictionary.erase(id_)
	self.npcCount -= 1
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
