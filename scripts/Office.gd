extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# closes office scene
func _on_QuitOffice_pressed():
	$EntireScreen/QuitOffice.material.set_shader_param("value", 1)
	get_node("/root/CityMap/HUD/TopBarBG/DashboardSelected").visible = false
	get_node("/root/CityMap/HUD/TopBarBG/AchievementSelected").visible = false
	get_node("/root/CityMap/HUD/TopBarBG/StoreSelected").visible = false
	get_node("/root/CityMap/HUD/TopBarBG/OfficeSelected").visible = false
	queue_free()



func _on_QuitOffice_mouse_entered():
	$EntireScreen/QuitOffice.material.set_shader_param("value", 0.3)


func _on_QuitOffice_mouse_exited():
	$EntireScreen/QuitOffice.material.set_shader_param("value", 1)


func _on_QuitOffice_button_down():
	$EntireScreen/QuitOffice.material.set_shader_param("value", 0.1)



func _on_Phone_pressed():
	var phone = preload("res://ui/hud/NPC_Interactions/Phone.tscn")
	var phone_instance = phone.instance()
	add_child(phone_instance)

func _on_Computer_pressed():
	$EntireScreen/Office/Computer/ComputerPic.visible = true


func _on_Worker_pressed():
	$EntireScreen/Office/Worker/DialogueBox.visible = true


func _on_Next_pressed():
	$Introduction.visible = false


func _on_WorkerNext_pressed():
	$EntireScreen/Office/Worker/DialogueBox.visible = false


func _on_ExitPhone_pressed():
	$EntireScreen/Office/Phone/PhonePic.visible = false


func _on_ExitComputer_pressed():
	$EntireScreen/Office/Computer/ComputerPic.visible = false


func _on_exit_phone_button_pressed():
	$EntireScreen/Office/Phone/phone_background.visible = false
	$EntireScreen/Office/Computer.visible = true
	$EntireScreen/Office/Worker.visible = true
