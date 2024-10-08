extends Node

# Singleton to load the tutorial json data
var convs: Array = []
func _ready():
	var file = File.new()
	if file.file_exists("res://resources/tutorial.json"):
		file.open("res://resources/tutorial.json", File.READ)
		var data = file.get_as_text()
		var parsed_data = JSON.parse(data).result
		convs = parsed_data["conversations"]
		file.close()
