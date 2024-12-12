extends Control

func _unhandled_input(event):
	if event is InputEventKey and event.scancode == 16777221:
		_on_Start_pressed()

func _on_Start_pressed():
	var _err = get_tree().change_scene("res://start_map.tscn")

func _on_LineEdit_text_changed(new_text):
	Global.userName = new_text
