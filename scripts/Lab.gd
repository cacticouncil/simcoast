extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#necessary for tutorial sequence
	Announcer.notify(Event.new("Lab", "Entered", 1))

#closes lab scene
func _on_QuitLab_pressed():
	#necessary for tutorial sequence
	Announcer.notify(Event.new("Lab", "Exited", 1))
	get_parent().remove_child(self)

#shading for quit lab button
func _on_QuitLab_mouse_entered():
	$LabBackground/QuitLab.material.set_shader_param("value", 0.3)
func _on_QuitLab_mouse_exited():
	$LabBackground/QuitLab.material.set_shader_param("value", 1)
func _on_QuitLab_button_down():
	$LabBackground/QuitLab.material.set_shader_param("value", 0.1)

#used to start dialogue with clark
func _on_Clark_pressed():
	$Clark/DialogueBox.visible = true 

#used to end dialogue with clark
func _on_WorkerNext_pressed():
	$Clark/DialogueBox.visible = false
