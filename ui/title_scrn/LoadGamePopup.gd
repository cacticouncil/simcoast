extends FileDialog


func _ready():
	add_filter("*.json ; JSON files")

func _on_LoadGameButton_pressed():
	access = FileDialog.ACCESS_USERDATA
	current_dir = "user://saves"
	
	var window_size = get_viewport_rect().size
	var dialog_size = Vector2(window_size.x / 3, window_size.y / 2)
	
	popup_centered(dialog_size)

func _on_LoadGamePopup_file_selected(path:String):
	if ".json" in path:
		Global.currentMap = path
		var _err = get_tree().change_scene("res://start_map.tscn")
	else:
		OS.alert('File chosen is of wrong type, the game specifically uses JSON files.', 'Warning')
