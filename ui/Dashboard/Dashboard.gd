extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_QuitButton_pressed():
	get_node("/root/CityMap/HUD/TopBarBG/DashboardSelected").visible = false
	$QuitButton.material.set_shader_param("value", 1)
	get_parent().remove_child(self)

func _on_QuitButton_button_down():
	$QuitButton.material.set_shader_param("value", 0.1)

func _on_QuitButton_mouse_entered():
	$QuitButton.material.set_shader_param("value", 0.3)

func _on_QuitButton_mouse_exited():
	$QuitButton.material.set_shader_param("value", 1)
