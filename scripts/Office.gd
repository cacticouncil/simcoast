extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# closes office scene
func _on_QuitOffice_pressed():
	$QuitOffice.material.set_shader_param("value", 1)
	get_node("/root/CityMap/HUD/TopBarBG/DashboardSelected").visible = false
	get_node("/root/CityMap/HUD/TopBarBG/AchievementSelected").visible = false
	get_node("/root/CityMap/HUD/TopBarBG/StoreSelected").visible = false
	get_node("/root/CityMap/HUD/TopBarBG/OfficeSelected").visible = false
	queue_free()



func _on_QuitOffice_mouse_entered():
	$QuitOffice.material.set_shader_param("value", 0.3)


func _on_QuitOffice_mouse_exited():
	$QuitOffice.material.set_shader_param("value", 1)


func _on_QuitOffice_button_down():
	$QuitOffice.material.set_shader_param("value", 0.1)



func _on_Phone_pressed():
	$Phone/PhonePic.visible = true


func _on_Computer_pressed():
	pass # Replace with function body.


func _on_Worker_pressed():
	$Worker/DialogueBox.visible = true


func _on_Next_pressed():
	$Introduction.visible = false


func _on_WorkerNext_pressed():
	$Worker/DialogueBox.visible = false


func _on_ExitPhone_pressed():
	$Phone/PhonePic.visible = false
