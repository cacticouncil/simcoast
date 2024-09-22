extends Object

class_name Options
var options: Array
var parent: String
# Options is an Array of (int, string) tuples
# The int is the index of the conversation array to go to if the option
# is to be selected.
# The string is the text of the actual option (e.g. Hear explanation again).

func _init(_options: Array, _parent: String):
	options = _options
	parent = _parent

func getOptions():
	return options
	
func getParent():
	return parent
