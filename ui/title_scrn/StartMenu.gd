extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	createUserFolders()
	disableContinueButton()
	
func disableContinueButton():
	print(SaveLoad.get_continue_map())
	if SaveLoad.get_continue_map() == "res://data/default.json":
		$MenuLayout/Buttons/ContinueButton.disabled = true

func createUserFolders():
	var dir = Directory.new()
	if not dir.dir_exists("user://saves"):
		dir.make_dir("user://saves")
		
	if not dir.dir_exists("user://data"):
		dir.make_dir("user://data")
		createContinueFile()
	elif not dir.file_exists("user://data/continue.json"):
		createContinueFile()
		

func createContinueFile():
	var continuePath = "user://data/continue.json"
	var data = {
		"previous_map_path": "res://data/default.json"
	}
	
	var file = File.new()
	file.open(continuePath, File.WRITE)
	file.store_line(JSON.print(data, "\t"))
	file.close()
		
func _on_MasterVolSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_QuitButton_pressed():
	var popup = get_node("QuitGamePopup/PopupDialog")
	if (popup != null):
		popup.popup_centered()
	else:
		get_tree().quit()


func _on_FullScreenToggle_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_MusicVolSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_SFXVolSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func _on_MasterMute_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !button_pressed)


func _on_MusicMute_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !button_pressed)


func _on_SFXMute_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), !button_pressed)


func _on_NewGameButton_pressed():
	Global.newGame = true
	var _err = get_tree().change_scene("res://start_map.tscn")
	
	
func _on_ContinueButton_pressed():
	Global.currentMap = SaveLoad.get_continue_map()
	var _err = get_tree().change_scene("res://start_map.tscn")
