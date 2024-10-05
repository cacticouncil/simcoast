extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Announcer.notify(Event.new("Lab", "Entered", 1))


func _on_QuitLab_pressed():
	Announcer.notify(Event.new("Lab", "Exited", 1))
	get_parent().remove_child(self)


func _on_QuitLab_mouse_entered():
	$LabBackground/QuitLab.material.set_shader_param("value", 0.3)


func _on_QuitLab_mouse_exited():
	$LabBackground/QuitLab.material.set_shader_param("value", 1)


func _on_QuitLab_button_down():
	$LabBackground/QuitLab.material.set_shader_param("value", 0.1)
