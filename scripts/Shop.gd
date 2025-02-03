extends Node

var container
var temp_container = []

# initializes shop scene
func _ready():	
	SceneManager.connect("sensor_info_clicked", self, "_sensor_callback")
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

# updates shop -> player can see popup after clicking more information/buy options
func _process(delta):
	var curr_desc = "Congrats! You just bought a " 
	var curr_desc2 = "! You now have "
	var curr_desc3 = " sensors in your inventory."
	var curr_desc3_1 = " sensor in your inventory."

	for sensor in Inventory.sensors:
		# opens successfull buy display
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
		# opens unsuccessfull buy display
		if sensor.cant_buy == true:
			$BuyBox.visible = true
			$BuyBox/BuyText.text = "Sorry! You do not have enough funds to buy this sensor."
			sensor.cant_buy = false

func _sensor_callback(sensor):
	var currSensor = sensor
	var lab = preload("res://ui/hud/NPC_Interactions/Lab.tscn")
	var lab_instance = lab.instance()
	add_child(lab_instance)
	
# closes shop scene
func _on_QuitShop_pressed():
	$QuitShop.material.set_shader_param("value", 1)
	get_node("/root/CityMap/HUD/TopBarBG/DashboardSelected").visible = false
	get_node("/root/CityMap/HUD/TopBarBG/AchievementSelected").visible = false
	get_node("/root/CityMap/HUD/TopBarBG/StoreSelected").visible = false
	queue_free()

# closes information popup
func _on_CloseInfo_pressed():
	for sensor in Inventory.sensors:
		if sensor.info_bttn == true:
			sensor.info_bttn = false
	$InformationBox.visible = false
	var minigame = preload("res://ui/Mini Game/MiniGame.tscn")
	var minigame_inst = minigame.instance()
	add_child(minigame_inst)


func _on_QuitShop_mouse_entered():
	$QuitShop.material.set_shader_param("value", 0.3)


func _on_QuitShop_mouse_exited():
	$QuitShop.material.set_shader_param("value", 1)


func _on_QuitShop_button_down():
	$QuitShop.material.set_shader_param("value", 0.1)

# closes buy popup
func _on_CloseBuy_pressed():
	Announcer.notify(Event.new("Buy popup", "Closed", 2))
	for sensor in Inventory.sensors:
		if sensor.buy_bttn == true:
			sensor.buy_bttn = false
	$BuyBox.visible = false
	
	var i = 0
	for c in temp_container:
		var currSen = Inventory.sensors[i]
		c.updateValues(currSen.get_name(),currSen.get_info(), currSen.get_req(), currSen.get_status())
		i +=1
