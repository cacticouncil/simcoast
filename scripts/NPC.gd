extends Object
class_name NPC

var id: int
var name: String
var type: int
var currentDialogue: int

func _init(id_, name_):
	self.id = id_
	self.name = name_
func getName():
	return self.name
func getID():
	return self.id
func getType():
	return self.type
func dialogueTrigger():
	#Access current dialogue and dialogue system
	print(currentDialogue)
