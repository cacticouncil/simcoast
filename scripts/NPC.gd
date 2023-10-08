extends Object
class_name NPC

var id: int
var name: String
var type: int
var playerDialogue: String
var npcDialogue: String
var dialogueSystem: DialogueSystem

func _init(id_, name_, playerDialogue_, npcDialogue_):
	self.id = id_
	self.name = name_
	#Two json files
	self.playerDialogue = playerDialogue_
	self.npcDialogue = npcDialogue_
	#Instantiate dialogue object, loads dialogue
	self.dialogueSystem = DialogueSystem.new(playerDialogue, npcDialogue)
func getName():
	return self.name
func getID():
	return self.id
func getType():
	return self.type
func dialogueTrigger():
	#Access current dialogue and dialogue system
	#print(currentDialogue)
	#Call next dialogue
	print()
