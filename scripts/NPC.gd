extends Object
class_name NPC

var id: int
var name: String
var type: int

func _init(id_, name_):
	self.id = id_
	self.name = name_
func getName():
	return self.name
func getID():
	return self.id
func getType():
	return self.type
