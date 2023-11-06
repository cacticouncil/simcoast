extends Node

var items = {
	"utility_plants": 0,
	'fire_station': 0,
	'hospital': 0,
	'police_station': 0,
	'utility_plant': 0,
	'sewage_facility': 0,
	'waste_treatment': 0,
	'park_button': 0,
	'library': 0,
	'museum': 0,
	'school': 0,
	'road': 0,
	'bridges': 0,
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

func remove_building(building):
	items[building] -= 1

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

func get_sensor_amount(var n):
	for sensor in sensors:
		if sensor.get_name() == n:
			return sensor.get_amount()
	return null

func increase_sensor_amount(var n):
	for sensor in sensors:
		if sensor.get_name() == n:
			sensor.increase_amount()

func decrease_sensor_amount(var n):
	for sensor in sensors:
		if sensor.get_name() == n:
			sensor.decrease_amount()
