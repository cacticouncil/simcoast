extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var npcList = Array()
var npcCount = 0
var rng = RandomNumberGenerator.new()


func _ready():
	addNPC("Carl")
	
func addNPC(npcName_):
	#Should add NPC as the name given and give unique ID as ascii value of NPCName
	self.npcCount += 1
	#Have a way of encrypting this? So it is reversable
	var npcID = rng.randf_range(0, 100)
	var npcObject = NPC.new(npcID, npcName_)
	self.npcList.append(npcObject)
	return
func deleteNPC(npcName_):
	self.npcCount -= 1
	return
func modifyNPC(npcName_):
	return

# Prints list of all NPC names
func printNPCList():
	for n in self.npcList:
		print(n.npcName)
		print("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
