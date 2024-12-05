extends Node

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


#shading for closing office scene button
func _on_QuitOffice_mouse_entered():
	$EntireScreen/QuitOffice.material.set_shader_param("value", 0.3)
#shading for closing office scene button
func _on_QuitOffice_mouse_exited():
	$EntireScreen/QuitOffice.material.set_shader_param("value", 1)
#shading for closing office scene button
func _on_QuitOffice_button_down():
	$EntireScreen/QuitOffice.material.set_shader_param("value", 0.1)

# opens phone scene
func _on_Phone_pressed():
	var phone = preload("res://ui/hud/NPC_Interactions/Phone.tscn")
	var phone_instance = phone.instance()
	add_child(phone_instance)

func _on_Computer_pressed():
	var computer = preload("res://ui/Dashboard/OfficeDashboard.tscn")
	var computer_instance = computer.instance()
	get_tree().root.add_child(computer_instance)


func _on_Worker_pressed():
	$EntireScreen/Office/Worker/DialogueBox.visible = true

#closes deputy mayor dialogue
func _on_WorkerNext_pressed():
	$EntireScreen/Office/Worker/DialogueBox.visible = false
