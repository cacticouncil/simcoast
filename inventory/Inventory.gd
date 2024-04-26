extends Node

#Giving players these items will make the next one free
var items = {
	"utility plant": 0,
	'fire station': 0,
	'hospital': 0,
	'police station': 0,
	'sewage facility': 0,
	'waste treatment': 0,
	'park': 0,
	'library': 0,
	'museum': 0,
	'school': 0,
	'road': 0,
	'water': 0,
	'bridge': 0,
	'house': 0, #don't use
	'apartment': 0, #don't use
	'shop': 0, #don't use
	'lt_res_zone': 0, #don't use
	'hv_res_zone': 0, #don't use
	'lt_com_zone': 0, #don't use
	'hv_com_zone': 0, #don't use
	"tide sensor": 0,
	"rain sensor": 0,
	"wind sensor": 0
}

var tide_info = "Used to measure the speed and\n height of the tide and other\n weather metrics."
var tide_ext_info = "A tide gauge is a device used to measure the change in sea level relative to the surface of land.\nSensors continuously record the height of the water level by measuring the distance to the water's surface and comparing it to the height of the land it is connected to.\nTide gauges are important sensors when predicting upcoming storms, since storms create higher waves."
var placeholder = "This is the extended sensor description. TBA"
var rain_info = "Used to measure the amount of\n rain fall an area has had over\n a period of time."
var wind_info = "Used to measure wind\n speed and air pressure."
var wind_ext_info = "A wind gauge is a device used to measure wind\n speed and pressure."
var sensors = []
var current_sensor = ""
var tide_bought = false
var rain_bought = false
var wind_bought = false


func get_inventory_data():
	var sensor_data = []
	
	for sensor in sensors:
		sensor_data.append(sensor.to_dict())
	
	var data = {
		"items": items,
		"sensors": sensor_data
	}
	
	return data

func load_inventory_data(data):
	items = data["items"]
	
	sensors.clear()
	
	# Create sensors
	var sensor1 = Sensor.new("", "", "", "")
	var sensor1Data = data["sensors"][0]
	
	# Override default data with saved data
	for key in sensor1Data:
		sensor1.set(key, sensor1Data[key])
	
	var sensor2 = Sensor.new("", "", "", "")
	var sensor2Data = data["sensors"][1]
	
	for key in sensor1Data:
		sensor2.set(key, sensor2Data[key])
	
	var sensor3 = Sensor.new("", "", "", "")
	var sensor3Data = data["sensors"][2]
	
	for key in sensor3Data:
		sensor3.set(key, sensor3Data[key])
		
	sensors.append(sensor1)
	sensors.append(sensor2)
	sensors.append(sensor3)
	
	# Update inventory numbers
	get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()

	
# adds all types of sensor currently available to inventory
func _ready():
	sensors.append(Sensor.new("Tide Gauge", tide_info, tide_ext_info, " "))
	sensors[0].set_status(true)
	sensors.append(Sensor.new("Rain Gauge", rain_info, placeholder,"Buy a Tide Gauge"))
	sensors.append(Sensor.new("Wind Gauge", wind_info, wind_ext_info, "Buy a Rain Gauge"))
# add building to inventory
func add_building(building):
	items[building] += 1
	get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()

# remove building from inventory
func remove_building(building):
	items[building] -= 1
	get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()

func removeIfHave(building):
	#Used to check if we have a building, remove it if we do. Returns true if sucessful
	if items[building] > 0:
		items[building] -= 1
		get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()
		return true
	return false

func get_number_of_buildings(building):
	return items[building]

func has_building(building):
	return items[building] > 0

func get_sensor_status(var n):
	for sensor in sensors:
		if sensor.get_name() == n:
			return sensor.get_status()
	return null

func change_sensor_status(var n, var s):
	for sensor in sensors:
		if sensor.get_name() == n:
			sensor.set_status(s)
			
func remove_sensor(s):
	items[s] -= 1
	if s == "tide sensor":
		for sensor in sensors:
			if sensor.get_name() == "Tide Gauge":
				sensor.decrease_amount()
	elif s == "rain sensor":
		for sensor in sensors:
			if sensor.get_name() == "Rain Gauge":
				sensor.decrease_amount()
	elif s == "wind sensor":
		for sensor in sensors:
			if sensor.get_name() == "Wind Gauge":
				sensor.decrease_amount()
	get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()

func update_sensor_amount():
	for sensor in sensors:
		if sensor.get_name() == "Tide Gauge":
			items["tide sensor"] = sensor.get_amount()
			if sensor.get_amount() != 0:
				tide_bought = true
		if sensor.get_name() == "Rain Gauge":
			items["rain sensor"] = sensor.get_amount()
			if sensor.get_amount() != 0:
				rain_bought = true
		if sensor.get_name() == "Wind Gauge":
			items["wind sensor"] = sensor.get_amount()
			if sensor.get_amount() != 0:
				wind_bought = true
	get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()

func bought(var s):
	if s == "Tide Gauge":
		return tide_bought
	elif s == "Rain Gauge":
		return rain_bought
	else:
		return wind_bought

func set_current_sensor(var s):
	current_sensor = s

func get_price(var n):
	for sensor in sensors:
		if sensor.get_name() == n:
			return sensor.price
