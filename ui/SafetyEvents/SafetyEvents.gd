extends CanvasLayer

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
