extends Object

class_name Dialogue
var text: String
var char_id: int
var parent_path: String

func _init(_text: String, _char_id: int, _parent_path = "/root/CityMap"):
	text = _text
	char_id = _char_id
	parent_path = _parent_path

func getText():
	return text

func getCharID():
	return char_id

func getParent():
	return parent_path
