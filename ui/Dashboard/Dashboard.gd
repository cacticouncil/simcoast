extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_QuitButton_pressed():
	$QuitButton.material.set_shader_param("value", 1)
	get_parent().remove_child(self)

func _on_QuitButton_button_down():
	$QuitButton.material.set_shader_param("value", 0.1)
