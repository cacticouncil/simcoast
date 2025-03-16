extends CanvasLayer

var mini_game = preload("res://ui/Mini Game/MiniGame.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Announcer.notify(Event.new("Beach", "Entered", 1))
	if Global.closeBeach:
		$Background.texture = preload("res://assets/beach/Beach Closed.png")



func _on_QuitBeach_pressed():
	get_parent().remove_child(self)
	
func _on_QuitBeach_mouse_entered():
	$Background/QuitBeach.material.set_shader_param("value", 0.3)


func _on_QuitBeach_mouse_exited():
	$Background/QuitBeach.material.set_shader_param("value", 1)


func _on_QuitBeach_button_down():
	$Background/QuitBeach.material.set_shader_param("value", 0.1)


func _on_Button_pressed():
	var parent = get_parent()
	var mini_game_inst = mini_game.instance()
	parent.add_child(mini_game_inst)
