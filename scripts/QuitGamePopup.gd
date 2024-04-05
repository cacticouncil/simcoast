extends PopupDialog

func _ready():
	var saveButton = get_node("CancelButton")
	saveButton.connect("pressed", self, "cancel_popup")
	
	var quitButton = get_node("QuitButton")
	quitButton.connect("pressed", self, "close_popup")

func cancel_popup():
	hide()

func close_popup():
	hide()
	get_tree().quit()
