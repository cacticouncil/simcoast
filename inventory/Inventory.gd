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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_building(building):
	items[building] += 1

func remove_building(building):
	items[building] -= 1

func get_number_of_buildings(building):
	return items[building]

func has_building(building):
	return items[building] > 0
