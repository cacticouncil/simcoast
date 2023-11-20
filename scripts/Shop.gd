extends Node
var container
var temp_container = []
func _ready():
	
	for i in range(Inventory.sensors.size()):
		# We have 3 achievements side by side, then print on the next row
		if i % 3 == 0:
			container = HBoxContainer.new()
			container.set("custom_constants/separation", 20)
			$ScrollContainer/Sensor1/Sensor2.add_child(container)
			# This random control node was the easiest way to get the first spacing
			container.add_child(Control.new())
		var Sen = preload("res://ui/hud/NPC_Interactions/SensorDisplay.tscn")
		var SenInstance = Sen.instance()
		temp_container.append(SenInstance)
		var currSen = Inventory.sensors[i]
		SenInstance.updateValues(currSen.get_name(), currSen.get_info(), currSen.get_req(), currSen.get_status())
		
		container.add_child(SenInstance)

func _process(delta):
	#var i = 0
	#for c in container.get_children():
	#	for cc in c.get_children():
	#	var currAch = Inventory.sensors[i]
	#	if i > 0:
	#		c.updateValues(currAch.get_name(), currAch.get_info(), currAch.get_req(), currAch.get_status())
	#	i +=1
	#	print(i)
		
	var curr_desc = "Congrats! You just bought a " 
	#var curr_name = $SensorsBG/SensorName.text
	var curr_desc2 = "! You now have "
	var curr_desc3 = " sensors."
	var curr_desc3_1 = " sensor."
	#var final_desc = curr_desc + curr_name + curr_desc2 + str(sensor_amount) + curr_desc3
	
	for sensor in Inventory.sensors:
		if sensor.info_bttn == true:
			$InformationBox.visible = true
			$InformationBox/infoText.text = sensor.get_ext_info()	
		if sensor.buy_bttn == true:
			var curr_name = sensor.get_name()
			var solo = curr_name.split(" ")[0].to_lower()
			var curr_amt = sensor.get_amount()
			var final_desc
			if curr_amt == 1:
				final_desc = curr_desc + curr_name + curr_desc2 + str(curr_amt) + " " + solo + curr_desc3_1
			else :
				final_desc = curr_desc + curr_name + curr_desc2 + str(curr_amt) + " " + solo + curr_desc3
			$BuyBox/BuyText.text = final_desc
			$BuyBox.visible = true
		if sensor.cant_buy == true:
			$BuyBox.visible = true
			$BuyBox/BuyText.text = "Sorry! You do not have enough funds to buy this sensor."
			sensor.cant_buy = false

func _on_QuitShop_pressed():
	$QuitShop.material.set_shader_param("value", 1)
	get_node("/root/CityMap/HUD/TopBarBG/DashboardSelected").visible = true
	get_node("/root/CityMap/HUD/TopBarBG/AchievementSelected").visible = false
	get_parent().remove_child(self)

func _on_CloseInfo_pressed():
	for sensor in Inventory.sensors:
		if sensor.info_bttn == true:
			sensor.info_bttn = false
	$InformationBox.visible = false


func _on_QuitShop_mouse_entered():
	$QuitShop.material.set_shader_param("value", 0.3)


func _on_QuitShop_mouse_exited():
	$QuitShop.material.set_shader_param("value", 1)


func _on_QuitShop_button_down():
	$QuitShop.material.set_shader_param("value", 0.1)


func _on_CloseBuy_pressed():
	for sensor in Inventory.sensors:
		if sensor.buy_bttn == true:
			sensor.buy_bttn = false
	$BuyBox.visible = false
	
	var i = 0
	for c in temp_container:
		var currSen = Inventory.sensors[i]
		c.updateValues(currSen.get_name(),currSen.get_info(), currSen.get_req(), currSen.get_status())
		i +=1
