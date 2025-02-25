extends Node

# Called when the node enters the scene tree for the first time.
#func updateValues(sName, sInfo, sReq, aPic, locked):
func updateValues(sName, sInfo, sReq, locked):
	if Inventory.get_sensor_status(sName) == false:
		$SensorsBG/Locked.visible = true
		$SensorsBG/SensorName.visible = false
	else:
		if Inventory.bought(sName) == false:
			$SensorsBG/SensorName/BuyButton.visible = true
		$SensorsBG/Locked.visible = false
		$SensorsBG/SensorName.visible = true
			
	$SensorsBG/SensorName.text = sName
	$SensorsBG/SensorName/SensorInfo.text = sInfo
	$SensorsBG/Locked/Req.text = sReq
	$SensorsBG/SensorName/BuyButton.text = "Buy: $" + str(Inventory.get_price(sName))
	#$SensorName/SensorImage.set_texture(load(aPic))

# buys sensor,if possible
func _on_BuyButton_pressed():
	var sensor_name = $SensorsBG/SensorName.text
	var curr_price = Inventory.get_price(sensor_name)
	
	#["tide sensor", "res://assets/buttons/tide_sensor", "Tide Gauge"]
	# purchases sensor if player has enough money
	if(Econ.purchase_structure(curr_price)):
		var i = 0
		var j = 0
		var happened = false
		var sensor_amount = 1
		for sensor in Inventory.sensors:
			if sensor.get_name() == $SensorsBG/SensorName.text:
				j = i + 1
				happened = true
				$SensorsBG/SensorName/BuyButton.visible = false
			# unlocks next sensor
			if i == j && happened == true:
				sensor.set_status(true)
			i +=1
		# increases price of bought sensor
		if happened==true:
			var new_price
			# edge case for first (free) sensor
			if curr_price == 0:
				new_price=5000
			else:
				new_price= curr_price*2		
			var button = [sensor_name.to_lower(), "res://assets/buttons/" + sensor_name.to_lower(), sensor_name]
			get_node("/root/CityMap/HUD/ToolsMenu").addSensorButton(button)		
			Inventory.sensors[j-1].price = new_price
			Inventory.sensors[j-1].increase_amount()
			Inventory.update_sensor_amount()
			Inventory.sensors[j-1].buy_bttn = true
	# player cannot buy sensor
	else:
		for sensor in Inventory.sensors:
			if sensor.get_name() == $SensorsBG/SensorName.text:
				sensor.cant_buy = true

# activate information popup
func _on_InfoButton_pressed():
	var sensorName = $SensorsBG/SensorName.text
	SceneManager.emit_signal("sensor_info_clicked", sensorName)

func _on_BuyClose_pressed():
	$SensorsBG/SensorName/BuyButton/BuyInfo.visible = false
