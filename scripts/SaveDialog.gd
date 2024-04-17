extends FileDialog

var lineEdit
var okButton

func _ready():
	okButton = get_ok()
	okButton.text = "Save"
	
	get_close_button().hide()
	add_filter("*.json ; JSON files")

func open():
	access = FileDialog.ACCESS_USERDATA
	current_dir = "user://saves"
	
	var window_size = get_viewport_rect().size
	var dialog_size = Vector2(window_size.x / 3, window_size.y / 2)
	
	popup_centered(dialog_size)

func _on_SaveButton_pressed():
	open()
	
