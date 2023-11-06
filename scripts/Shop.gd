extends Node
var tide_info = "A tide gauge is a device used to measure the change in sea level relative to the surface of land.\nSensors continuously record the height of the water level by measuring the distance to the water's surface and comparing it to the height of the land it is connected to.\nTide gauges are important sensors when predicting upcoming storms, since storms create higher waves."
func _ready():

	var container
	
	for i in range(Inventory.sensors.size()):
		# We have 3 achievements side by side, then print on the next row
		if i % 3 == 0:
			container = HBoxContainer.new()
			container.set("custom_constants/separation", 20)
			$ScrollContainer/Sensor1/Sensor2.add_child(container)
			# This random control node was the easiest way to get the first spacing
			container.add_child(Control.new())
		var Ach = preload("res://ui/hud/NPC_Interactions/SensorDisplay.tscn")
		var AchInstance = Ach.instance()
		
		var currAch = Inventory.sensors[i]
		AchInstance.updateValues(currAch.get_name(), currAch.get_info(), currAch.get_req(), currAch.get_status())
		
		container.add_child(AchInstance)



func _on_QuitShop_pressed():
	$QuitShop.material.set_shader_param("value", 1)
	get_node("/root/CityMap/HUD/TopBarBG/DashboardSelected").visible = true
	get_node("/root/CityMap/HUD/TopBarBG/AchievementSelected").visible = false
	get_parent().remove_child(self)

func _on_CloseInfo_pressed():
	$InformationBox.visible = false


func _on_InfoButton1_pressed():
	$InformationBox.visible = true
	$InformationBox/infoText.bbcode_text = tide_info

func _on_QuitShop_mouse_entered():
	$QuitShop.material.set_shader_param("value", 0.3)


func _on_QuitShop_mouse_exited():
	$QuitShop.material.set_shader_param("value", 1)


func _on_QuitShop_button_down():
	$QuitShop.material.set_shader_param("value", 0.1)
