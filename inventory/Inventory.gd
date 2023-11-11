extends Node

var items = {
	"utility_plant": 1,
	'fire_station': 0,
	'hospital': 0,
	'police_station': 0,
	'sewage_facility': 0,
	'waste_treatment': 0,
	'park': 2,
	'library': 0,
	'museum': 0,
	'school': 0,
	'road': 10,
	'water': 0,
	'bridges': 0,
	'lt_res_zone': 0, #don't use
	'hv_res_zone': 0, #don't use
	'lt_com_zone': 0, #don't use
	'hv_com_zone': 0, #don't use
	"tide_sensor": 0,
	"rain_sensor": 0
}

var tide_info = " Used to measure the speed and\n height of the tide and other\n weather metrics."
var rain_info = " Used to measure the amount of\n rain fall an area has had over\n a period of time."
var gen_info = " This is a sensor that measures \n something. TBA"
var sensors = []

func _ready():
	sensors.append(Sensor.new("Tide Gauge", tide_info, " "))
	sensors[0].set_status(true)
	sensors.append(Sensor.new("Rain Gauge", rain_info, "Buy a Tide Gauge"))
	sensors.append(Sensor.new("GEN1 Gauge", gen_info, "Buy a Rain Gauge"))
	sensors.append(Sensor.new("GEN2 Gauge", gen_info, "Buy a GEN1 Gauge"))

func add_building(building):
	items[building] += 1
	get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()

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

func update_sensor_amount():
	for sensor in sensors:
		if sensor.get_name() == "Tide Gauge":
			items["tide_sensor"] = sensor.get_amount()
		if sensor.get_name() == "Rain Gauge":
			items["rain_sensor"] = sensor.get_amount()
	get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()
	
