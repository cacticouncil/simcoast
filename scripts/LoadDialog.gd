extends FileDialog

var lineEdit

func _ready():
	lineEdit = get_line_edit()
	lineEdit.grab_focus()
	
	add_filter("*.json ; JSON files")

func _on_LoadButton_pressed():
	access = FileDialog.ACCESS_USERDATA
	current_dir = "user://saves"
	
	var window_size = get_viewport_rect().size
	var dialog_size = Vector2(window_size.x / 3, window_size.y / 2)
	
	popup_centered(dialog_size)
