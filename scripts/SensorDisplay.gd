extends Node

# Called when the node enters the scene tree for the first time.
#func updateValues(sName, sInfo, sReq, aPic, locked):
func updateValues(sName, sInfo, sReq, locked):
	if Inventory.get_sensor_status(sName) == false:
		$SensorsBG/Locked.visible = true
		$SensorsBG/SensorName.visible = false
	else:
		$SensorsBG/Locked.visible = false
		$SensorsBG/SensorName.visible = true
			
	$SensorsBG/SensorName.text = sName
	$SensorsBG/SensorName/SensorInfo.text = sInfo
	$SensorsBG/Locked/Req.text = sReq
	#$SensorName/SensorImage.set_texture(load(aPic))


func _on_BuyButton_pressed():
	var i = 0
	var j = 0
	var happened = false
	for sensor in Inventory.sensors:
		if sensor.get_name() == $SensorsBG/SensorName.text:
			j = i + 1
			happened = true
		if i == j && happened == true:
			sensor.set_status(true)
		i +=1
