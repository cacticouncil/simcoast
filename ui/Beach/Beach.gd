extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Announcer.notify(Event.new("Beach", "Entered", 1))



func _on_QuitBeach_pressed():
	get_parent().remove_child(self)
	
func _on_QuitBeach_mouse_entered():
	$Background/QuitBeach.material.set_shader_param("value", 0.3)


func _on_QuitBeach_mouse_exited():
	$Background/QuitBeach.material.set_shader_param("value", 1)


func _on_QuitBeach_button_down():
	$Background/QuitBeach.material.set_shader_param("value", 0.1)
