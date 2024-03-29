extends Object
class_name NPC

var id: int
var name: String
var type: int
var playerDialogue: String
var npcDialogue: String
var dialogueSystem: DialogueSystem
var icon: String
var unlocked: bool
var description: String

func _init(id_, name_, playerDialogue_, npcDialogue_, icon_, description_):
	self.id = id_
	self.name = name_
	#Two json files
	self.playerDialogue = playerDialogue_
	self.npcDialogue = npcDialogue_
	#For character cards
	self.icon = icon_
	self.description = description_
	self.unlocked = false
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
	dialogueSystem.dialogueSequence(id)
