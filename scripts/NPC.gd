extends Object
class_name NPC

var id: int
var name: String
var type: int
var playerDialogue: String
var npcDialogue: String
var icon: String
var unlocked: bool
var description: String

func _init(id_, name_, icon_, description_):
	self.id = id_
	self.name = name_
	#For character cards
	self.icon = icon_
	self.description = description_
	self.unlocked = false

func getName():
	return self.name
func getID():
	return self.id
func getType():
	return self.type
