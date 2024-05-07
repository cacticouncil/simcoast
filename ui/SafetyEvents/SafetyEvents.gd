extends CanvasLayer

func _ready():
	$Rows/BeachClose/Control/Buttons.get_child(UpdateWeather.beachClose).pressed = true

func _on_QuitButton_pressed():
	$QuitButton.material.set_shader_param("value", 1)
	get_node("/root/CityMap/HUD/TopBarBG/AchievementSelected").visible = false
	queue_free()

func _on_QuitButton_mouse_entered():
	$QuitButton.material.set_shader_param("value", 0.3)

func _on_QuitButton_mouse_exited():
	$QuitButton.material.set_shader_param("value", 1)

func _on_QuitButton_button_down():
	$QuitButton.material.set_shader_param("value", 0.1)

func _on_CloseBeach_pressed(value):
	if !$Rows/BeachClose/Control/Buttons.get_child(value).pressed:
		$Rows/BeachClose/Control/Buttons.get_child(value).pressed = true
	UpdateWeather.beachClose = value
	var buttons = $Rows/BeachClose/Control/Buttons.get_children()
	var i = 0
	for button in buttons:
		if i != value:
			button.pressed = false
		i += 1
